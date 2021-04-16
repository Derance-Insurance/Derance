<template>
    <div id="wRANCEAndRANCE" v-loading.fullscreen.lock="loading"
        :element-loading-text="loadingText">

        <el-row>
            <h2 class="main-text">wRANCE token</h2>
            <div class="normal-text">Wrap/Unwrap RANCE tokens to an address</div>
        </el-row>
        <el-divider></el-divider>
        <el-row>
          <el-form :model="form" ref="form" label-width="150px" :disabled="!member.isMember">
            <el-form-item label="Your Account" class="normal-text">
              <el-tag hit effect="dark">
                {{member.account}}
              </el-tag>
            </el-form-item>
            <el-form-item label="wRANCE Contract" class="normal-text">
              <el-tag hit effect="dark">
                {{tokenAddress}}
              </el-tag>
            </el-form-item>
            <el-form-item label="Amount" prop="amount">
              <el-input placeholder="Please enter an amount" class="right-input" v-model="form.amount" @change="changeAmount">
              </el-input>
              <highlight red>{{error}}</highlight>
            </el-form-item>
            <el-form-item>
              <el-button :disabled="!isWrap" type="primary" @click="wrap" round>Wrap</el-button>
              <el-button :disabled="!isUnwrap" @click="unwrap" round>UnWrap</el-button>
            </el-form-item>
          </el-form>
        </el-row>
        <br/>
        <el-row>
          <el-form ref="balanceForm" inline label-width="150px">
            <el-form-item label="RANCE Balance" class="normal-text">
                <div style="width: 300px;">
                  <el-tag type="success" hit>
                    {{formatterBalance(member.balance)}}
                  </el-tag>
                  RANCE
                </div>
            </el-form-item>
            <el-form-item label="wRANCE Balance" class="normal-text">
                <el-tag type="success" hit>
                  {{formatterBalance(member.wbalance)}}
                </el-tag>
                wRANCE
            </el-form-item>
          </el-form>
          <el-form ref="wrapForm" inline label-width="150px">
            <el-form-item label="Can Wrap" class="normal-text">
                <div style="width: 300px;">
                  <el-tag v-if="canWrapRANCE && canWrapRANCE['0']" type="success">Yes</el-tag>
                  <el-tag v-else type="danger">{{canWrapRANCE ? canWrapRANCE['1'] : "N/A"}}</el-tag>
                </div>
            </el-form-item>
            <el-form-item label="Can UnWrap" class="normal-text">
                <el-tag v-if="canUnWrapRANCE && canUnWrapRANCE['0']" type="success">Yes</el-tag>
                <el-tag v-else type="danger">{{canUnWrapRANCE ? canUnWrapRANCE['1'] : "N/A"}}</el-tag>
            </el-form-item>
          </el-form>
        </el-row>
    </div>
</template>

<script>
import { mapGetters } from 'vuex';
import { watch } from '@/utils/watch.js';
import wRANCEContract from '@/services/wRANCE';
import { BigNumber } from 'bignumber.js'

export default {
  name: "wRANCEAndRANCE",
  components: {  },
  data() {
    return {
        loading: false,
        loadingText: "loading...",
        wRANCE: null, // 合约
        form: {
            amount: "",
        },
        canWrapRANCE: null,
        canUnWrapRANCE: null,
        error: "",
    }
  },
  computed: {
    ...mapGetters([
      'web3',
      'member',
      'web3Status',
      'settings'
    ]),
    tokenAddress(){
      if(this.wRANCE && this.wRANCE.contract){
        return this.wRANCE.contract.address;
      }
      return "";
    },
    isWrap(){
      return this.validateAmount(this.member.balance, false) && this.canWrapRANCE && this.canWrapRANCE['0'];
    },
    isUnwrap(){
      return this.validateAmount(this.member.wbalance, false) && this.canUnWrapRANCE && this.canUnWrapRANCE['0'];
    }
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
    formatterBalance(balance){
      try{
          return this.$etherToNumber(balance);
      }catch(e){
          console.info(e);
          return 'N/A';
      }
    },
    initData(){
      if(this.web3Status === this.WEB3_STATUS.AVAILABLE){
        this.initContract();
      }
    },
    async initContract(){
      this.wRANCE = await this.getContract(wRANCEContract);
      console.info("wRANCE:", this.wRANCE);
    },
    canWrap(){
      const contract = this.wRANCE.getContract();
      // 转成string，否则prod打包后会报错
      const fee = this.$ether(this.form.amount).toString();
      contract.instance.canWrap(this.member.account, fee).then(response => {
        console.info(response, response.toString());
        this.canWrapRANCE = response;
      }).catch((e) => {
        console.error(e);
        this.canWrapRANCE = "No";
      });
    },
    canUnWrap(){
      const contract = this.wRANCE.getContract();
      const fee = this.$ether(this.form.amount).toString();
      contract.instance.canUnwrap(this.member.account, this.member.account, fee).then(response => {
        console.info(response, response.toString());
        this.canUnWrapRANCE = response;
      }).catch((e) => {
        console.error(e);
        this.canUnWrapRANCE = "No";
      });
    },
    wrap(){
      if(!this.validateAmount(this.member.balance)){
        return;
      }
      try{
        this.loading = true;
        const contract = this.wRANCE.getContract();
        const fee = this.$ether(this.form.amount).toString();
        contract.instance.wrap(fee, { from: this.member.account}).then(response => {
          console.info(response, response.toString());
          this.$message.success("Wrap successfully");
          this.loading = false;
          this.$Bus.$emit("refresh");
        }).catch((e) => {
          console.error(e);
          this.$message.error(e.message);
          this.loading = false;
        });
      }catch(e){
        console.error(e);
        this.loading = false;
      }
    },
    unwrap(){
      if(!this.validateAmount(this.member.wbalance)){
        return;
      }
      try{
        this.loading = true;
        const contract = this.wRANCE.getContract();
        const fee = this.$ether(this.form.amount).toString();
        contract.instance.unwrap(fee, { from: this.member.account}).then(response => {
          console.info(response, response.toString());
          this.$message.success("Unwrap successfully");
          this.loading = false;
          this.$Bus.$emit("refresh");
        }).catch((e) => {
          console.error(e);
          this.$message.error(e.message);
          this.loading = false;
        });
      }catch(e){
        console.error(e);
        this.loading = false;
      }
    },
    changeAmount(){
      if(this.validateAmount()){
        this.canWrap();
        this.canUnWrap();
      }
    },
    showError(message, show){
      if(show){
        this.$message.error(message);
      }
      this.error = message;
    },
    validateAmount(balance, showMessage){
      try{
        if(!balance){
          this.error = "";
        }
        const value = this.form.amount;
        if(value==0){
          this.showError("The amount must be greater than 0", showMessage);
          return false;
        }
        const result = /^((0(\.[0-9]+)?)|([1-9][0-9]*(\.[0-9]+)?))$/g.test(value);
        if(!result){
            this.showError('Please enter a valid amount', showMessage);
            return false;
        }
        if(balance==null || balance==undefined){
            return true;
        }
        const amountBN = BigNumber(this.$ether(value));
        const balanceBN = BigNumber(balance);
        if(amountBN.comparedTo(balanceBN)>0){
            this.showError('Insufficient funds', showMessage);
            return false;
        }
        return true;
      }catch(e){
        this.showError(e.message, showMessage);
        return false;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
    @import '@/styles/element-variables.scss';
    #wRANCEAndRANCE {
      padding-bottom: 20px;
      .el-form{
        .el-input{
          width: 200px;
        }
      }
      .el-tag{
        font-size: 14px;
      }
      .li-highlight[red]{
        color:  #425faf;
        margin-left: 20px;
      }
    }
    .tip{
      line-height: 60px;
    }
    .icon{
      margin-right: 10px;
    }
    .right {
      position: absolute;
      right: 0px;
      top: 0px;
    }
    .right-rate {
      float: right;
      line-height: 40px;
    }
    .balance {
      background-color:  #485e9b;
      color: #FFFFFF !important;
    }
    .box-card-to{
      background-color: #DCDFE6;
      color: #909399;
    }
</style>
<style lang="scss">
    #wRANCEAndRANCE .right-input {
        .el-input__inner {
            text-align: right !important;
        }
    }
</style>
