({
	myMember : function(component, event, helper) {
		var action = component.get("c.getMember");
         action.setCallback(this, function(a){
            component.set("v.member", a.getReturnValue());
            console.log(component.get("v.member"));
        });
        $A.enqueueAction(action);
    },

    openAgreementModal : function(component, event, helper) {
        //console.log(event.getParam("name"));
        if (event.getParam("name") != 'Agreement') return;
        var lType = event.getParam("type");
        component.set("v.youbetType", lType);
        //helper.loadAgreement(component, event);
        var member = component.get('v.member');
        console.log(member);
        if(!member) return;

        $('#agreementModal').fadeIn(200);
        var action =  component.get("c.getRewardAgreement");
        action.setParams({
            aMemberId : member.Id,
            aType : lType            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.agreement",response.getReturnValue());
                component.set("v.reward",response.getReturnValue());
                console.log(response.getReturnValue());
                // var showAccept = response.getReturnValue().Id != member.FieloPLT__Agreement__c;
                // component.set("v.showAccept", showAccept);
            } else {
                console.log('Erro ao carregar o regulamento');
            }
        });
        $A.enqueueAction(action);       
    },
    openSpyAgreementModal : function(component, event, helper) {
        //console.log(event.getParam("name"));
        if (event.getParam("name") != 'Agreement') return;
        //helper.loadAgreement(component, event);
        var member = component.get('v.member');
        console.log(member);
        if(!member) return;

        $('#agreementModal').fadeIn(200);
        var action =  component.get("c.getRewardAgreement");
        action.setParams({
            aMemberId : member.Id           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.agreement",response.getReturnValue());
                component.set("v.reward",response.getReturnValue());
                console.log(response.getReturnValue());
                // var showAccept = response.getReturnValue().Id != member.FieloPLT__Agreement__c;
                // component.set("v.showAccept", showAccept);
            } else {
                console.log('Erro ao carregar o regulamento');
            }
        });
        $A.enqueueAction(action);       
    },

    closeModal : function(component, event, helper) {
    	$('#agreementModal').fadeOut(200);
    },
    onClick: function (component, event, helper) {
        helper.onCheck(component, event); 
    },
})