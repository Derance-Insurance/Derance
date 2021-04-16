<template>
  <div id="stats-token" class="app-container">
    <el-divider content-position="left">
      <h4>Token</h4>
    </el-divider>
    <el-form label-width="200px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="RANCE Price">
            <highlight>1 RANCE = {{options.rate}} BNB</highlight>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="RANCE Supply">
            <highlight>
              <span v-format="'#,##0.00'">{{$etherToNumber(totalSupply)}}</span> RANCE
            </highlight>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="RANCE Market Cap">
            <highlight>$<span v-format="'#,##0.00'">{{totalSupplyUSD}}</span></highlight>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="Unique Addresses">
            <el-button type="text" @click="open">RANCE Holders Addresses</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
import {mapGetters} from 'vuex'
import {watch} from "@/utils/watch";
import RANCETokenContract from '@/services/RANCEToken';
import { BigNumber } from 'bignumber.js';

export default {
  components: { },
  props: ["options"],
  data() {
    return {
      RANCEToken: null,
      totalSupply: 0,
    }
  },
  computed: {
    ...mapGetters(['web3Status', 'member', 'settings']),
    bnbTotalSupply(){
      return BigNumber(this.$etherToValue(this.totalSupply)).times(this.options.rate).toFixed(2, 1);
    },
    totalSupplyUSD(){
      return BigNumber(this.bnbTotalSupply).times(this.member.bnbQuote).toFixed(2, 1);
    }
  },
  watch: {
    web3Status: watch.web3Status
  },
  created() {
    this.initData();
    this.$Bus.bindEvent(this.$EventNames.switchAccount, this._uid, ()=>{
      this.initData();
    });
  },
  methods: {
    initData() {
      if(this.web3Status === this.WEB3_STATUS.AVAILABLE){
        this.initContract();
      }
    },
    async initContract(){
      if(!this.RANCEToken) this.RANCEToken = await this.getContract(RANCETokenContract);
      this.getTokenSupply();
    },
    getTokenSupply(){
      const instance = this.RANCEToken.getContract().instance;
      instance.totalSupply().then(res => {
        this.totalSupply = res.toString();
      });
    },
    open(){
      window.open(this.settings.uniqueAddresses);
    }
  }
}
</script>
<style lang="scss" scoped>
#stats-token{
  .address{

  }
}
</style>
