import request from '@/utils/request.js'
import RANCEMasterContract from '@/services/RANCEMaster';
import RANCETokenContract from '@/services/RANCEToken';
import MCRContract from '@/services/MCR';
import wRANCEContract from '@/services/wRANCE';
import { BNB_BYTE8 } from '@/utils/Constants'

export const getSettings = (vue) => {
  return request({
      url:`/data/settings.json`,
      method:'get'
  });
}
// Initialize member information and determine whether it is a member
export async function initMember(vue){
  if(!vue.$CustomWeb3.account){
    vue.$store.dispatch("member/setStatus", false);
    vue.$store.dispatch("member/setLoading", false);
    return;
  }
  const RANCEMaster = await vue.getContract(RANCEMasterContract);
  const contract = RANCEMaster.getContract();
  contract.instance.isMember(vue.$CustomWeb3.account).then(response=>{
    console.info("isMember:", response);
    vue.$store.dispatch("member/setLoading", false);
    vue.$store.dispatch("member/setStatus", response);
  }).catch((e)=>{
    vue.$message.error(`Loading member status failed. ${e.toString()}`);
    vue.$store.dispatch("member/setLoading", false);
  });
}

// Determine whether it is a member
export async function isMember(vue, account){
  const RANCEMaster = await vue.getContract(RANCEMasterContract);
  const contract = RANCEMaster.getContract();
  try{
    const result = contract.instance.isMember(account);
    return result;
  }catch(e){
    vue.$message.error(`Loading member status failed. ${e.message}`);
    return false;
  }
}

export async function getAllowance(vue, contractAddress){
  if(!vue.$CustomWeb3.account){
    return -1;
  }
  const RANCEToken = await vue.getContract(RANCETokenContract);
  const contract = RANCEToken.getContract();
  try{
    const allowance = await contract.instance.allowance(vue.$CustomWeb3.account, contractAddress);
    console.info("Allowance: ", allowance.toString());
    return allowance.toString();
  }catch(e){
    console.error(e);
    vue.$message.error(e.message);
    return -1;
  }
}

export async function getBalance(vue){
  if(!vue.$CustomWeb3.account){
    return;
  }
  const RANCEToken = await vue.getContract(RANCETokenContract);
  const contract = RANCEToken.getContract();
  contract.instance.balanceOf(vue.$CustomWeb3.account).then(response => {
    console.info("RANCE Balance: ", response.toString());
    vue.$store.dispatch("member/setBalance", response.toString());
  }).catch((e) => {
    console.error(e);
    vue.$message.error(e.message);
  });
}

export async function getWBalance(vue){
  if(!vue.$CustomWeb3.account){
    return;
  }
  const wRANCE = await vue.getContract(wRANCEContract);
  const contract = wRANCE.getContract();
  contract.instance.balanceOf(vue.$CustomWeb3.account).then(response => {
    console.info("wRANCE Balance: ", response.toString());
    vue.$store.dispatch("member/setWBalance", response.toString());
  }).catch((e) => {
    console.error(e);
    vue.$message.error(e.message);
  });
}

// Authorized transaction amount to the contract
export async function grantAllowance(vue, contractAddress, allowance){
  const RANCEToken = await vue.getContract(RANCETokenContract);
  const contract = RANCEToken.getContract();
  try{
    await contract.instance.approve(contractAddress, allowance.toString(), { from: vue.$CustomWeb3.account });
    console.info("New allowance: ", allowance.toString());
    return true;
  }catch(e){
    vue.$message.error(e.message);
  }
  return false;
}

//Check the exchange rate of BNB and RANCE
export async function getRate(vue){
  const MCR = await vue.getContract(MCRContract);
  const contract = MCR.getContract();
  try{
    const result = contract.instance.calculateTokenPrice(BNB_BYTE8);
    return result;
  }catch(e){
    vue.$message.error(`Loading member status failed. ${e.message}`);
    return false;
  }
}

//Check the exchange rate of BNB and USD
export async function getBNBQuote(vue){
  request({
    url:`/bnb-price/`,
    method:'get',
  }).then(res => {
    console.log(res)
    vue.$store.dispatch("member/changeMember", {
      key: "bnbQuote",
      value: res.data.price
    });
  }).catch(e => {

  });
}
