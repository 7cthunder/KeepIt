<template>
  <ul class="contractInfo">
    <li v-for="(item, key) in contract" v-bind:key="key">
      <strong>{{ item.name }}:</strong>
      {{ item.value }}
    </li>
  </ul>
</template>

<script>
import { keepitContract } from "../utils/contract.js";

export default {
  name: "ContractInfo",
  props: ["contract"]
};
</script>

<style>
.contractInfo {
  margin: 20px auto;
  list-style: none;
  padding: 0;
}
</style>
