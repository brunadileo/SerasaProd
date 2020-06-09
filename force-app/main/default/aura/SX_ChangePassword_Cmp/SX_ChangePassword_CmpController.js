({
	openSpyAgreementModal : function(cmp, event, helper) {
        $('#updatePassword').fadeIn(200);
    },

    closeModal : function (cmp, event, helper) {
        $('#updatePassword').fadeOut(200);
        component.get("v.msg", "");
        component.get("v.showMsg", false);
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());  
         //   helper.updatePassword(component, event); 
        });
        $A.enqueueAction(action);
    },
    updatePassword : function(component, event, helper) {

        component.set("v.showMsgError", false);

        var member = component.get("v.member");
        if(!member) return;

        var password = component.find("newUpdatePass").get("v.value");
        var confirmPassword = component.find("confirmUpdatePassword").get("v.value");


        if(!password || !confirmPassword){
            component.set("v.msg", "Informe e confirme a nova senha");
            component.set("v.showMsgError", true);
            component.find("newUpdatePass").set("v.value", "");
            component.find("confirmUpdatePassword").set("v.value", "");
            return;
        }

        if(password != confirmPassword){
            component.set("v.msg", "Os valores informados estão diferentes");
            component.set("v.showMsgError", true);
            component.find("newUpdatePass").set("v.value", "");
            component.find("confirmUpdatePassword").set("v.value", "");
            return;
        }

        var action = component.get('c.getChangePassword');
        var param = new Object();
        param.aIdUser = member.FieloPLT__User__c;
        param.aPassword = password;
        action.setParams(param);
        action.setCallback(this, function(response){ 

            var returnValue = response.getReturnValue();

            if(!returnValue){
                component.set("v.msg", "Ocorreu um erro ao atualizar a senha");
                component.set("v.showMsgError", true);
                component.find("newUpdatePass").set("v.value", "");
                component.find("confirmUpdatePassword").set("v.value", "");
            } else {

                if(returnValue.includes("Ok")) {
                    component.set("v.showMsgSuccess", true);  
                } else{
                    component.set("v.msg", returnValue);
                    component.set("v.showMsgError", true); 
                    component.find("newUpdatePass").set("v.value", "");
                    component.find("confirmUpdatePassword").set("v.value", "");
                }
            }
             
        });
        $A.enqueueAction(action);
    },
})