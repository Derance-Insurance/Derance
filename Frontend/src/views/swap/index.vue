<template>
  <div id="swap" class="app-container">
    <StartMembership/>
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="BNB & RANCE" name="bnb">
        <BNBAndRANCE @refresh="refreshAllowance"/>
      </el-tab-pane>
      <el-tab-pane label="WRANCE & RANCE" name="wRANCE">
        <wRANCEAndRANCE @refresh="refreshAllowance" />
      </el-tab-pane>

    </el-tabs>

  </div>
</template>

<script>
import BNBAndRANCE from '@/views/swap/BNBAndRANCE'
import wRANCEAndRANCE from '@/views/swap/wRANCEAndRANCE'
import { watch } from '@/utils/watch.js';
import { mapGetters } from 'vuex';
import { getBNBQuote } from '@/api/common.js'

export default {
  components:{
      BNBAndRANCE,
      wRANCEAndRANCE,
  },
  data() {
    return {
      activeName: "bnb",
    }
  },
  computed: {
    ...mapGetters([
      'web3',
      'member',
      'web3Status',
	  'settings'
    ]),
  },
  watch: {
    web3Status: watch.web3Status,
  },
  created(){
    this.initData();
    this.$Bus.bindEvent(this.$EventNames.switchAccount, this._uid, (account)=>{
      this.initData();
    });
  },
  methods: {
    initData(){
      if(this.web3Status === this.WEB3_STATUS.AVAILABLE){
        this.initContract();
      }
    },
    async initContract(){
      this.refreshAllowance();
      getBNBQuote(this);
    },
    handleClick(tab){
      this.refreshAllowance();
    },
    refreshAllowance(){
      if(this.activeName == "bnb"){
        this.$Bus.$emit(this.$EventNames.refreshAllowance, this.settings.contracts.TokenController, "TokenController");
      }else{
        this.$Bus.$emit(this.$EventNames.refreshAllowance, this.settings.contracts.wRANCE, "wRANCE");
      }
    }
  }
}
</script>
<style lang="scss" scoped>
@import '@/styles/element-variables.scss';
#swap{

}
</style>
