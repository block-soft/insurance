$(document).ready(function() {
    $.ajaxSetup({ cache: false });
});

try {
    var url = "http://localhost:8545";
    var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
    var adminAccount = web3.eth.accounts[0];
    var investorAccount = web3.eth.accounts[2];
    var investorAccount2 = web3.eth.accounts[3];
    var customerAccount = web3.eth.accounts[4];
    var customerAccount2 = web3.eth.accounts[5];
    var customerAccount3 = web3.eth.accounts[6];
    var otherAccount = web3.eth.accounts[7];

    window.addEventListener('load', function () {
        //deploy contract, not needed in real mode
        UiAlerts.addSuccess('web3', 'loaded')
        ContractsInit.deployInsurance();
    });
} catch (e) {
    UiAlerts.addError('web3', e.toString())
}

var ContractsInit = {
    deployInsurance: function () {
        $.ajax({
            type: 'GET',
            cache: false,
            url: './no_cache.php?f=Insurance.json',
            //other settings
            success: function(json) {
                var tmpContract = web3.eth.contract(json.abi);
                Contracts.insurance = tmpContract.new({
                        from: adminAccount,
                        data: json.unlinked_binary,
                        gas: 4100000
                    },
                    function (e, contract) {
                        if (e) {
                            UiAlerts.addError('deploy Insurance Contract', e.toString());
                        } else {
                            if (contract.address) {
                                UiAlerts.addSuccess('deployed InsuranceContract', contract.address);
                                ContractsInit.firstData();
                            }
                        }
                    });
            }
        });
    },
    firstData: function(){
        //first investors to show data
        InsuranceInvestor.invest(investorAccount2, 20000, 20, false);
        InsuranceInvestor.invest(investorAccount2, 30000, 40, true);
        ContractsInit.finish();
    },
    finish: function () {
        $('#loading_boxes').hide();
        $('#loaded_boxes').show();
        UiMenu.show('menu_open', 'content_open');
    }
};

var Contracts = {
    //contract
    insurance: false,
    //default action for common use
    runInsurance: function (action, params) {
        if (typeof(Contracts.insurance[action]) == 'undefined') {
            UiAlerts.addError(action, 'action undefined');
            return false;
        }
        Contracts.insurance[action].estimateGas(
            Contracts.insurance.address,
            params,
            function (e, gas) {
                if (e) {
                    UiAlerts.addError(action + 'Gas', e.toString().substr(0, 100));
                } else {
                    var params2 = params;
                    params2.gas = gas;
                    Contracts.insurance[action](
                        Contracts.insurance.address,
                        params2,
                        function (e, hash) {
                            if (e) {
                                UiAlerts.addError(action, e.toString().substr(0, 100));
                            } else {
                                UiAlerts.addSuccess(action, hash);
                            }
                        }
                    );
                }
            }
        );
        return false;
    }
};