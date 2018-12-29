<template>
  <div>
    <b-form class="search" @submit="onSearch" inline>
      <label class="sr-only" for="contractAddress">Contract Address</label>
      <b-input
        id="contractAddress"
        v-model="contractAddress"
        class="mr-2"
        size="sm"
        :state="state"
        aria-describedby="addressLiveFeedback"
        placeholder="请输入合约地址"
      />
      <b-button type="submit" variant="outline-secondary" size="sm">查询</b-button>
      <b-form-invalid-feedback id="addressLiveFeedback">请输入正确的合约地址</b-form-invalid-feedback>
    </b-form>
    <contract-info :contract="contractInfo" v-show="show"/>
    <div class="error-info" v-if="showError">{{errorInfo}}</div>
    <pay
      type="加入"
      :state="userAuthState"
      :feedback="feedback"
      :user="user"
      v-on:submit="onSubmit"
      showmoney="true"
      v-if="show"
    />
  </div>
</template>

<script>
import pay from "./Pay.vue";
import contractInfo from "./ContractInfo.vue";

import { web3, keepitContract } from "../utils/contract.js";
import { time2String } from '../utils/time.js'

export default {
  name: "JoinPage",
  components: {
    pay,
    contractInfo
  },
  data() {
    return {
      show: false,
      user: null,
      userAuthState: {
        address: null,
        password: null
      },
      feedback: "",
      contractAddress: "",
      state: null,
      errorInfo: "",
      showError: false,
      contractInfo: {
        clockInTime: {
          name: "打卡时间",
          value: null
        },
        keepDays: {
          name: "持续天数",
          value: null
        },
        groupSize: {
          name: "小组人数",
          value: null
        },
        isStart: {
          name: "是否开始",
          value: null
        }
      }
    };
  },
  created() {
    if (!this.$route.params.userAddress) return;
    this.contractAddress = this.$route.params.contractAddress;
    this.show = true;
    this.onSearch({});
    this.user = {
      address: this.$route.params.userAddress,
      password: this.$route.params.userPassword
    };
  },
  methods: {
    onSearch(evt) {
      if (evt.preventDefault) evt.preventDefault();
      let me = this;
      /* clear info */
      me.show = false
      me.state = null
      try {
        keepitContract.options.address = me.contractAddress;
        /* get clock in time */
        keepitContract.methods
          .clockInTime()
          .call()
          .then(function(time) {
            me.contractInfo.clockInTime.value = time2String(time);
          });
        /* get keep days */
        keepitContract.methods
          .keepDays()
          .call()
          .then(function(days) {
            me.contractInfo.keepDays.value = days;
          });
        /* get group size */
        keepitContract.methods
          .groupSize()
          .call()
          .then(function(size) {
            me.contractInfo.groupSize.value = size;
          });
        /* get group state */
        keepitContract.methods
          .isStart()
          .call()
          .then(function(isStart) {
            var result = isStart ? "是" : "否";
            me.contractInfo.isStart.value = result;
          });
        me.show = true;
      } catch (error) {
        this.state = false;
        this.show = false;
      }
    },
    onSubmit(evt) {
      this.userAuthState = {
        address: null,
        password: null
      };
      this.showError = false;
      this.feedback = "";
      let me = this;
      let userInfo = evt.args[0];
      try {
        web3.eth.personal
          .unlockAccount(userInfo.address, userInfo.password)
          .then(function(result) {
            keepitContract.options.address = me.contractAddress;
            keepitContract.methods
              .isMember()
              .call({ from: userInfo.address })
              .then(function(yes) {
                if (yes) {
                  me.showError = true;
                  me.errorInfo = "您已是小组成员啦";
                  return;
                }
                keepitContract.methods
                  .join()
                  .send({ from: userInfo.address, value: userInfo.money })
                  .then(function() {
                    var contracts = localStorage.getItem(userInfo.address)
                      ? localStorage.getItem(userInfo.address).split(",")
                      : [];
                    contracts.push(me.contractAddress);
                    localStorage.setItem(userInfo.address, contracts);
                    me.$router.push({
                      name: 'keepPage', 
                      params: { 
                        address: me.contractAddress,
                        user: {
                          userAddress: userInfo.address,
                          userPassword: userInfo.password
                        }
                      }})
                  })
                  .catch(function(error) {
                    console.log(error);
                    me.showError = true;
                    me.errorInfo = "加入失败，请确认押金数额小于您的余额";
                  });
              });
          })
          .catch(function(error) {
            me.userAuthState.password = false;
            me.feedback = "用户密码错误!";
          });
      } catch (error) {
        this.userAuthState.address = false;
        this.feedback = "请输入正确的用户地址";
      }
    }
  }
};
</script>

<style scope>
#contractAddress {
  width: 88%;
}
.error-info {
  color: red;
}
</style>
