({
    youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'YoubetsPerformed') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        component.set("v.youbetType", event.getParam("type"));
        var today = new Date();
        component.set('v.dataDe', "2018-01-01");
        component.set('v.dataAte', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        helper.loadResultados(component, event); 
        $('#youbetsPerformed').show(200);
    },

    closeModal : function (component, event, helper) {
        $('#youbetsPerformed').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden');
        }
        component.set("v.showAgreement", false); 
        component.set("v.agreementByReward", null); 
        component.set('v.dataDe', "");
        component.find("palavraChave").set("v.value", "");
        component.set("v.lstRewards",null);
        component.set("v.tableCols", ""); 
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());  
        });
        $A.enqueueAction(action);
    },
    loadResultados : function(component, event, helper) {
        helper.loadResultados(component, event); 
    },
    searchOnEnter : function (component, event, helper) {
        if(event.getParams().keyCode == 13){
            helper.loadResultados(component, event);
        }
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
      //  console.log('###: ' + JSON.stringify(row));
        switch (action.name) {
            case 'show_agreement':

                var action =  component.get("c.getAgreement");
                action.setParams({ aIdReward : row.Id });
                action.setCallback(this, function(response) {
                    component.set("v.agreementByReward",response.getReturnValue());
                });
                $A.enqueueAction(action);
                component.set("v.showAgreement", true); 
                break;
        }
    },
    backToTable: function(component, event, helper) { 
        component.set("v.showAgreement", false); 
        component.set("v.agreementByReward", null); 
    },
})