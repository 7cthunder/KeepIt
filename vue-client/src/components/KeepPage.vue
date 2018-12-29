<template>
  <div>
    <contract-info :contract="contractInfo"/>
    <div class="error-info" v-if="showError">{{ errorInfo }}</div>
    <div class="success-info" v-if="showInfo">{{ successInfo }}</div>
    <pay
      type="打卡"
      :state="userAuthState"
      :feedback="feedback"
      showmoney="false"
      :user="user"
      v-on:submit="onSubmit"
    />
  </div>
</template>

<script>
import contractInfo from "./ContractInfo.vue";
import pay from "./Pay.vue";

import { web3, keepitContract } from "../utils/contract.js";
import { time2String } from "../utils/time.js";

export default {
  name: "KeepPage",
  props: ["address"],
  components: {
    contractInfo,
    pay
  },
  data() {
    return {
      user: null,
      userAuthState: {
        address: null,
        password: null
      },
      feedback: "",
      showError: false,
      errorInfo: '',
      showInfo: false,
      successInfo: '',
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
    this.user = {
      address: this.$route.params.userAddress,
      password: this.$route.params.userPassword
    }
    let me = this;
    try {
      keepitContract.options.address = me.address;
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
  methods: {
    onSubmit(evt) {
      this.userAuthState = {
        address: null,
        password: null
      };
      this.showError = false;
      this.feedback = "";

      let me = this;
      let userInfo = evt.args[0];
      var t1 = new Date()
      var hour = t1.getHours()
      var minute = t1.getMinutes()
      var now = hour * 3600 + minute * 60
      var t2 = me.contractInfo.clockInTime.value.split(':')
      var clt = parseInt(t2[0]) * 3600 + parseInt(t2[1]) * 60
      
      if (now >= clt) {
        me.showError = true
        me.errorInfo = '您已超过打卡时间，明天早点来哦~'
        return
      }
      try {
        web3.eth.personal
          .unlockAccount(userInfo.address, userInfo.password)
          .then(function(result) {
            keepitContract.options.address = me.contractAddress;
            keepitContract.methods
              .clockIn()
              .send({ from: userInfo.address })
              .then(function(result) {
                if (result) {
                  me.showInfo = true
                  me.successInfo = '打卡成功'
                }
              })
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

<style>
.error-info {
  color: red;
}
.success-info {
  color: green;
}
</style>
