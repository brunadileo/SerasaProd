({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();    
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();
        component.set('v.isUsernamePasswordEnabled', helper.getIsUsernamePasswordEnabled(component, event, helper));
        component.set("v.isSelfRegistrationEnabled", helper.getIsSelfRegistrationEnabled(component, event, helper));
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        component.set("v.communitySelfRegisterUrl", helper.getCommunitySelfRegisterUrl(component, event, helper));
    },
    
    handleLogin: function (component, event, helper) {
        helper.handleLogin(component, event, helper);
    },
    
    setStartUrl: function (component, event, helper) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
    
    onKeyUp: function(component, event, helper){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helper.handleLogin(component, event, helper);
        }
    },
    
    navigateToForgotPassword: function(component, event, helper) {
        var forgotPwdUrl = component.get("v.communityForgotPasswordUrl");
        if ($A.util.isUndefinedOrNull(forgotPwdUrl)) {
            forgotPwdUrl = component.get("v.forgotPasswordUrl");
        }
        var attributes = { url: forgotPwdUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },
    
    navigateToSelfRegister: function(component, event, helper) {
        var selrRegUrl = component.get("v.communitySelfRegisterUrl");
        if (selrRegUrl == null) {
            selrRegUrl = component.get("v.selfRegisterUrl");
        }
    
        var attributes = { url: selrRegUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },

    forgotPassword: function(component, event, helper) {
        var loginModal = $A.get("e.c:SX_LoginModal_Evt");
        loginModal.setParams({"function" : "forgotPassword"});
        loginModal.fire();
    },

    setPassword: function(component, event, helper) {
   
    },

    firstAccess: function(component, event, helper) {
        var numRegistro = component.find("username").get('v.value');
        console.log(numRegistro);
        if (!numRegistro) {
            component.set("v.errorMessage",'Necessário preencher número de registro');
            component.set("v.showError",true);
            return;
        }
        var loginModal = $A.get("e.c:SX_LoginModal_Evt");
        loginModal.setParams({function : "firstAccessBack", numeroRegistro: numRegistro});
        loginModal.fire();
    },

    firstAccessSubmit: function(component, event, helper) {

    },

    forgotPassword2: function(component, event, helper) {

    }
})