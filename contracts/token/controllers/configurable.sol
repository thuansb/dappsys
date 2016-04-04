import 'dapple/debug.sol';

import 'auth.sol';

import 'data/balance_db.sol';
import 'data/approval_db.sol';

import 'token/controllers/base.sol';
import 'token/hooks/default.sol';

import 'util/safety.sol';



contract DSConfigurableTokenController is DSTokenController, Debug{
    DSTokenSystemTransferHookType[] transfer_hooks;
    DSTokenSystemTransferFromHookType[] transferFrom_hooks;
    DSTokenSystemApproveHookType[] approve_hooks;
    
    mapping( bytes8 => address ) _refs;
    function getLocalRef(bytes8 name) internal returns (address) {
        return _refs[name];
    }

    function DSConfigurableTokenController( DSTokenFrontend frontend, DSBalanceDB baldb, DSApprovalDB apprdb )
             DSTokenController( frontend, baldb, apprdb )
    {
    }

    function transfer( address _caller, address to, uint value )
             auth() 
             returns (bool)
    {
        logs("in transfer 333333");
        for(var i = 0; i < transfer_hooks.length; i++ ) {
            transfer_hooks[i].transfer( _caller, to, value );
        }
        return true;
    }
    function transferFrom( address _caller, address from, address to, uint value )
             auth()
             returns (bool)
    {
        logs("in transferFrom");
        for(var i = 0; i < transferFrom_hooks.length; i++ ) {
            transferFrom_hooks[i].transferFrom( _caller, from, to, value );
        }
        return true;

    }
    function approve( address _caller, address spender, uint value)
             auth()
             returns (bool)
    {
        for(var i = 0; i < approve_hooks.length; i++ ) {
            approve_hooks[i].approve( _caller, spender, value );
        }
        return true;
    }

    function setTransferHook( uint8 index, DSTokenSystemTransferHookType hook )
             auth()
    {
        if (transfer_hooks.length < index+1 )
            transfer_hooks.length = index+1;
        transfer_hooks[index] = hook;
    }
    function setTransferFromHook( uint8 index, DSTokenSystemTransferFromHookType hook )
             auth()
    {
        if (transferFrom_hooks.length < index+1 )
            transferFrom_hooks.length = index+1;
        transferFrom_hooks[index] = hook;
    }
    function setApproveHook( uint8 index, DSTokenSystemApproveHookType hook )
             auth()
    {
        if (approve_hooks.length < index+1 )
            approve_hooks.length = index+1;
        approve_hooks[index] = hook;
    }

}

