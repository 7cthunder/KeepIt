<template>
  <div>
    <hr>
    <b-form-group label="账户地址:" label-for="userAddress">
      <b-form-input
        id="userAddress"
        size="sm"
        v-model="payForm.address"
        :state="state.address"
        aria-describedby="addressLiveFeedback"
        required
        placeholder="请输入账户地址"
      ></b-form-input>
      <b-form-invalid-feedback id="addressLiveFeedback">{{ feedback }}</b-form-invalid-feedback>
    </b-form-group>
    <b-form-group label="账户密码:" label-for="userPassword">
      <b-form-input
        id="userPassword"
        size="sm"
        type="password"
        v-model="payForm.password"
        :state="state.password"
        aria-describedby="passwordLiveFeedback"
        required
        placeholder="请输入账户密码"
      ></b-form-input>
      <b-form-invalid-feedback id="passwordLiveFeedback">{{ feedback }}</b-form-invalid-feedback>
    </b-form-group>
    <b-form-group label="押金:" label-for="userPassword" v-if="showMoney">
      <b-form-input
        id="money"
        size="sm"
        type="number"
        v-model="payForm.money"
        required
        placeholder="请输入您想支付的押金"
      ></b-form-input>
    </b-form-group>
    <b-button class="mybtn" @click="onClick" size="sm" variant="outline-primary">{{ type }}</b-button>
    <b-button class="mybtn" @click="onReset" size="sm" type="reset" variant="outline-danger">重置</b-button>
  </div>
</template>

<script>
export default {
  name: "Pay",
  props: ["type", "state", "feedback", "user", "showmoney"],
  data() {
    return {
      payForm: {
        address: "",
        password: "",
        money: ''
      },
      showMoney: false
    };
  },
  created() {
    this.showMoney = this.showmoney === 'true' ? true : false
    if (this.user) {
      this.payForm.address = this.user.address
      this.payForm.password = this.user.password
    }
  },
  methods: {
    onClick() {
      this.$emit("submit", { args: [this.payForm] });
    },
    onReset() {
      (this.payForm.address = ""), (this.payForm.password = "");
    }
  }
};
</script>

<style>
.mybtn {
  width: 80px;
}
</style>
