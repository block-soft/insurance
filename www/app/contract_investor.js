//web3 for investor
var InsuranceInvestor = {

    invest: function (address, gives, gets, update_pull) {
        if (typeof(update_pull) == 'undefined') {
            update_pull = true;
        }
        var params = {
            from: address,
            value : gives
        };

        Contracts.insurance.becomeInvestor.estimateGas(
            address,
            params,
            function (e, gas) {
                if (e) {
                    UiAlerts.addError('becomeInvestor Gas', e.toString().substr(0, 100));
                } else {
                    var params2 = params;
                    params2.gas = gas * 20;
                    Contracts.insurance.becomeInvestor(
                        gets * 1000,
                        params2,
                        function (e, hash) {
                            if (e) {
                                UiAlerts.addError('becomeInvestor', e.toString().substr(0, 100));
                            } else {
                                UiAlerts.addSuccess('becomeInvestor', 'address: ' + address + ' gives:' + gives + ', gets:' + gets + ', tx:' + hash);
                                if (update_pull) {
                                    InsurancePublic.investorsPull();
                                }
                            }
                        }
                    );
                }
            }
        );
    },

    cancel: function (address, index) {
        var params = {
            from: address
        };
        Contracts.insurance.proposalCancel.estimateGas(
            address,
            params,
            function (e, gas) {
                if (e) {
                    UiAlerts.addError('proposalCancel Gas', e.toString().substr(0, 100));
                } else {
                    var params2 = params;
                    params2.gas = gas * 20;
                    Contracts.insurance.proposalCancel(
                        index,
                        params2,
                        function (e, hash) {
                            if (e) {
                                UiAlerts.addError('proposalCancel', e.toString().substr(0, 100));
                            } else {
                                UiAlerts.addSuccess('proposalCancel', 'address: ' + address + ' cancels:' + index + ', tx:' + hash);
                            }
                        }
                    );
                }
            }
        );
    }
}