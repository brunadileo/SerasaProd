({
	loadBadgesElite : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action = component.get('c.getBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'Elite';
		action.setParams(param);
        action.setCallback(this, function(response){
            component.set("v.lstElite", response.getReturnValue());       
        });
        $A.enqueueAction(action);

        var action2 = component.get('c.getMyBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'Elite';
		action2.setParams(param);
        action2.setCallback(this, function(response){
            component.set("v.totalElite", response.getReturnValue());       
        });
        $A.enqueueAction(action2);
	},
	loadBadgesYouBet : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action = component.get('c.getBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'YouBet';
		action.setParams(param);
        action.setCallback(this, function(response){
            component.set("v.lstYB", response.getReturnValue());       
        });
        $A.enqueueAction(action);

        var action2 = component.get('c.getMyBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'YouBet';
		action2.setParams(param);
        action2.setCallback(this, function(response){
            component.set("v.totalYB", response.getReturnValue());       
        });
        $A.enqueueAction(action2);
	},
	loadBadgesEngajamento : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action = component.get('c.getBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'Engajamento';
		action.setParams(param);
        action.setCallback(this, function(response){
            component.set("v.lstEngajamento", response.getReturnValue());       
        });
        $A.enqueueAction(action);

        var action2 = component.get('c.getMyBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelSalesPersonYear__c;
		param.aType = 'Engajamento';
		action2.setParams(param);
        action2.setCallback(this, function(response){
            component.set("v.totalEngajamento", response.getReturnValue());       
        });
        $A.enqueueAction(action2);
	},
})