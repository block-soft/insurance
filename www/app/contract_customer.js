//сustomer api
var InsuranceCustomer = {
    search : function(customer_wants) {
        $('#customer_percent').hide();
        var proposals_count = Contracts.insurance.proposalsCount();
        var min_percent = 100000000;
        var min_id = 0;
        for(var j=1; j<= proposals_count; j++) {

            var proposal = Contracts.insurance.getProposal(j).toString().split(',');
            var investor = proposal[0];
            var gives = proposal[1];
            var gets = proposal[2];
            var left = proposal[3];
            var paid = proposal[4];
            var canceled = proposal[5];
            var percent = gets / 1000;

            if (left < customer_wants) {
                continue;
            }
            if (min_percent > percent) {
                min_percent = percent;
                min_id = j;
            }
        }
        if (min_percent < 100000000) {
            var pay = customer_wants * min_percent / 100;
            $('#customer_gets').val(min_percent);
            $('#customer_gets2').val(min_percent);
            $('#customer_pay_id').val(min_id);
            $('#customer_pay').val(pay);
            $('#customer_percent').show();
        } else {
            UiAlerts.addError('Not enough', 'No balance to cover ' + customer_wants);
        }

    },
    buyByID: function (address, pays, proposal_id, update_pull) {
        var params = {
            from: address,
            value : pays
        };
        if (typeof(update_pull) == 'undefined') {
            update_pull = true;
        }
        var fname = 'becomeCustomer';

        if (typeof(Contracts.insurance[fname]) == 'undefined') {
            UiAlerts.addError('no function ' + fname);
            return false;
        }
        Contracts.insurance[fname].estimateGas(
            proposal_id,
            params,
            function (e, gas) {
                if (e) {
                    UiAlerts.addError(fname + ' Gas', e.toString().substr(0, 100));
                } else {
                    var params2 = params;
                    params2.gas = gas * 10;
                    Contracts.insurance[fname](
                        proposal_id,
                        params2,
                        function (e, hash) {
                            if (e) {
                                UiAlerts.addError(fname, e.toString().substr(0, 100));
                            } else {
                                UiAlerts.addSuccess(fname, 'address: ' + address + ' pays:' + pays + ', investor gets:' + investor_gets + ', tx:' + hash);
                                if (update_pull) {
                                    InsurancePublic.customersPull();
                                    InsurancePublic.investorsPull();
                                }
                            }
                        }
                    );
                }
            }
        );
    }
}