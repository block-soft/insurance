//web3 for public data
var InsurancePublic = {
    investorsPull : function () {
        var html = '';
        var investors_count = Contracts.insurance.investorsCount().toString();
        var proposals_count = Contracts.insurance.proposalsCount().toString();
        html += '<h3 style="padding-top:10px;">Investors : ' + investors_count + ' with ' + proposals_count + ' proposals</h3>';

        var html_subs = {};
        for(var j = 1; j<= proposals_count; j++) {
            var proposal = Contracts.insurance.getProposal(j).toString().split(',');
            var investor = proposal[0];
            var gives = proposal[1];
            var gets = proposal[2];
            var left = proposal[3];
            var paid = proposal[4];
            var canceled = proposal[5];
            var percent = gets / 1000;

            if (typeof(html_subs[investor]) == 'undefined') {
                html_subs[investor] = '';
            }

            html_subs[investor] +=
                '<div class="row">' +
                '<div class="col-md-2">' +
                ' id: ' + j +
                '</div>' +
                '<div class="col-md-4">' +
                ' gives: ' + gives +
                ' for ' + percent + '%' +
                (canceled == 'true' ? ' <span style="color:red">[x]</span>' : '') +
                '</div>' +

                '<div class="col-md-4">' +
                ' left: ' + left +
                ' customers paid: ' + paid +
                '</div>' +
                '</div>';
        }
        for(var i = 1; i<= investors_count; i++) {
            var investor = Contracts.insurance.getInvestor(i).toString().split(',');

            var addr = investor[0];
            var balance = investor[1];
            var free = investor[2];
            html += '<div style="margin-top:10px; padding:10px; border:1px solid green;">'
                + ' <b>' + i + '. ' + addr + '</b>'
                + ' <span class="badge"> total put in system: ' + balance
                + ' </span>'
                + ' <span class="badge"> ready to withdraw: ' + free
                + ' </span>';
            if (!(typeof(html_subs[addr]) == 'undefined')) {
                html += html_subs[addr];
            }
            html += '</div>';
        }
        $('#investors_pull').html(html);
    },

    customersPull : function () {
        var html = '';
        var customers_count = Contracts.insurance.customersCount().toString();
        html += '<h3 style="padding-top:10px;">Customers : ' + customers_count + '</h3>';
        html += '<div style="margin-top:10px; padding:10px; border:1px solid green;">';

        var html_subs = {};
        for(var j = 1; j<= customers_count; j++) {
            var customer = Contracts.insurance.getCustomer(j).toString().split(',');
            var addr = customer[0];
            var paid = customer[1];
            var gets = customer[2];

            html += '<div class="row">' +
                '<div class="col-md-4">' +
                addr.substr(0, 12) + '...' +
                '</div>' +
                '<div class="col-md-4">' +
                ' gets: ' + gets +
                '</div>' +
                '<div class="col-md-4">' +
                ' total paid: ' + paid +
                '</div>' +
                '</div>';

        }
        html += '</div>';

        $('#customers_pull').html(html);
    }
}