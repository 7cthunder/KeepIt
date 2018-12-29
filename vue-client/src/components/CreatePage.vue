<template>
  <div>
    <b-form @submit="onSubmit" @reset="onReset" v-if="show">
      <b-form-group label="打卡时间:"
                    label-for="clockInTime"
                    description="请输入小组每天的打卡时间">
        <b-form-input id="clockInTime"
                      type="time"
                      size="sm"
                      v-model="form.clockInTime"
                      required>
        </b-form-input>
      </b-form-group>
      <b-form-group label="坚持天数:"
                    label-for="keepDays"
                    description="请输入小组打卡天数">
        <b-form-input id="keepDays"
                      type="number"
                      size="sm"
                      v-model="form.keepDays"
                      required>
        </b-form-input>
      </b-form-group>
      <b-form-group label="小组容量:"
                    label-for="groupSize"
                    description="请输入小组人数（至多20人）">
        <b-form-input id="groupSize"
                      type="number"
                      size="sm"
                      v-model="form.groupSize"
                      required>
        </b-form-input>
      </b-form-group>
      <pay type="创建" 
           :state="userAuthState"
           :feedback="feedback"
           showmoney=false 
           v-on:submit="onSubmit" />
    </b-form>
  </div>
</template>

<script>
import pay from './Pay.vue'

import { web3, keepitContract } from '../utils/contract.js'
import { string2Time } from '../utils/time.js'

export default {
  name: 'CreatePage',
  components: {
    pay
  },
  data () {
    return {
      form: {
        clockInTime: '08:00',
        keepDays: '1',
        groupSize: '1'
      },
      show: true,
      userAuthState: {
        address: null,
        password: null
      },
      feedback: ''
    }
  },
  methods: {
    onSubmit(evt) {
      this.userAuthState = {
        address: null,
        password: null
      }
      this.feedback = ''
      let me = this

      if (evt.preventDefault) evt.preventDefault()
      else {
        let userInfo = evt.args[0]
        try {
          web3.eth.personal.unlockAccount(userInfo.address, userInfo.password)
          .then(function (result) {
            var clockInTime = string2Time(me.form.clockInTime)
            keepitContract.deploy({
              arguments: [clockInTime, me.form.keepDays, me.form.groupSize]
            })
            .send({ from: userInfo.address })
            .on('error', function(error) {
              console.log(error)
            })
            .then(function(newContractInstance) {
              me.$router.push({
                name: 'join', 
                params: { 
                  contractAddress: newContractInstance.options.address,
                  userAddress: userInfo.address,
                  userPassword: userInfo.password
                }
              })
            })
            
          })
          .catch(function (error) {
            me.userAuthState.password = false
            me.feedback = '用户密码错误!'
          })
        } catch (error) {
          console.log(error);
          
          this.userAuthState.address = false
          this.feedback = '请输入正确的用户地址'
        }
        
      }
    },
    onReset(evt) {
      evt.preventDefault()
      this.form.clockInTime = '08:00'
      this.form.keepDays = '1'
      this.form.groupSize = '1'
      // this.show = false;
      // this.$nextTick(() => { this.show = true });
    }
  }
}


</script>
