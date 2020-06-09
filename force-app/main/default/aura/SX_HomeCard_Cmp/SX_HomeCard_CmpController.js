({
 	myMember : function(component, event, helper) {
		var action =component.get("c.getMember");
         action.setCallback(this, function(a){ 
         	
            component.set("v.member", a.getReturnValue()); 
            helper.myReward(component, event);  
            helper.loadDadosMeta(component, event); 
            helper.loadRanking(component, event);
            helper.loadVagas(component, event);
            helper.loadNumBadges(component, event); 
        });
        $A.enqueueAction(action);
	},
    openYoubetHome : function(component, event, helper) {   
        window.open('./youbet-home', '_self');
    },
    openYoubetExtra : function(component, event, helper) {  
        window.open('./youbet-extra-home', '_self');
    }
})