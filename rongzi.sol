pragma solidity ^0.4.0;

contract rongzi{
    
    struct needer{//小微企业
        address Neederaddress;//地址
        uint amount;//账户余额
        uint goal;//需要融资的资金
        uint funderAccount;//对接的金融公司id
        mapping(uint => funder) map;//映射，将金融公司id与小微企业绑定在一起，从而能得知是谁给当前的小微企业提供了融资
        
    }
    
    struct funder{//金融公司
        address funderaddress;//地址
        uint Tomoney;//提供融资的金额
    }
    
    uint neederAmount;//创建一个need库放在区块链上
    mapping(uint => needer) needmap;//通过mapping将小微企业id和小微企业绑定在一起从而能够管理小微企业
    
    function NewNeeder(address _Neederaddress, uint _goal){//发起一个融资请求
        //将小微企业和小微企业绑定
        neederAmount++;//需要融资的小微企业代号+1
                                      //账户地址     目标金额 账户目前没有钱  目前没有对接的金融公司
        needmap[neederAmount] = needer(_Neederaddress,_goal,        0,              0);
        
    }
                                                              //打钱必备
    function contribute( address _address, uint _neederAmount) payable{//回复融资请求 通过id获取到小微企业对象
             //默认storage类型   拿到在区块链上的一个needer实例
        needer storage _needer = needmap[_neederAmount];
        
        _needer.amount += msg.value; //给needer账户添加一笔钱
        _needer.funderAccount++;//给needer融资的金融机构+1
                         //金融机构账户       金融机构地址  提供融资的金额
        _needer.map[_needer.funderAccount] = funder(_address, msg.value);//将小微企业id绑定小微企业
    }
    
    function IScompelete( uint _neederAmount){//确认融资完成
        needer storage _needer = needmap[_neederAmount];//同上
        
        if(_neederAmount == _needer.goal){//如果账户里出现的金额和申请融资的目标金额一致
            _needer.Neederaddress.transfer(_needer.amount);//把_needer.amount转移到needer的地址上去
        }
    }
    
    function test() view returns( uint ,uint, uint){
        //显示器
        return (needmap[1].goal, needmap[1].amount,needmap[1].funderAccount);//显示参数
    }
}
