({
 
 	myMember : function(component, event, helper) {
		var action =component.get("c.getMember");
        action.setCallback(this, function(a){  
            component.set("v.Member", a.getReturnValue());
             helper.loadAgreement(component, event); 

        });
        $A.enqueueAction(action);
	},
    
    buscaMember : function(component, event, helper) {
        console.log("HOME - Busca Member");

        var actionTypeUser =component.get("c.isAdmin");
        actionTypeUser.setCallback(this, function(a){ 

            if(a.getReturnValue()){
                component.set("v.loaded", true);
                component.set("v.agreed", true); 
            } 
        });
        $A.enqueueAction(actionTypeUser);

        var action =component.get("c.getMember");
        action.setCallback(this, function(a){  
            component.set("v.Member", a.getReturnValue());
            helper.loadAgreement(component, event); 
        });
        $A.enqueueAction(action);
    },

	buscaString : function(component, event, helper) {
		var action = component.get("c.retornaString");
        action.setCallback(this, function(a){  
            component.set("v.Member", a.getReturnValue());
        });
        $A.enqueueAction(action);
	},
    acceptAgreement : function(component, event, helper) {

        helper.acceptAgreement(component, event); 
    },
})