({
	doInit : function(component, event, helper) {
		var action = component.get("c.getMember");
         action.setCallback(this, function(a){
            let lMember = a.getReturnValue(); 
            component.set("v.lMember", lMember);
            if(lMember){
                helper.redirect(a.getReturnValue().V_PapelYoubet__c, a.getReturnValue().V_PapelElite__c, a.getReturnValue().V_PapelSalesPersonYear__c);     
            }
        });
        $A.enqueueAction(action);
    }
})