({
    
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },

    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleLogin: function (component, event, helpler) {
        console.log('--->>> ');
        component.set('v.errorMessage','');
        var username = component.find('username');
        console.log('--1->>> '+username.get('v.value'));
        $A.util.removeClass(username, 'login-error animated faster-ish shake');
        var password = component.find('password');
        console.log('--2->>> '+password.get('v.value'));
        $A.util.removeClass(password, 'login-error animated faster-ish shake');
        var action = component.get('c.login');
        var startUrl = component.get('v.startUrl');

        if(!password.get('v.value') || !username.get('v.value')){
            $A.util.addClass(username, 'login-error animated faster-ish shake');
            $A.util.addClass(password, 'login-error animated faster-ish shake');
            component.set("v.errorMessage", 'É necessário preencher os dois campos');
            component.set("v.showError",true);
            return;
        }
        
        startUrl = decodeURIComponent(startUrl);
        action.setParams({registroMember:username.get('v.value'), password:password.get('v.value'), startUrl:startUrl});
        action.setCallback(this, function(response){
            var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                $A.util.addClass(username, 'login-error animated faster-ish shake');
                $A.util.addClass(password, 'login-error animated faster-ish shake');
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
                //$( "#toggle" ).effect( "shake" );
            }
        });
        $A.enqueueAction(action);
    },

    handleForgotPassword: function (component, event, helpler) {
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");
        
        startUrl = decodeURIComponent(startUrl);
        action.setParams({registroMember:username, password:password, startUrl:startUrl});
        action.setCallback(this, function(response){
            var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(response){
        var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isUsernamePasswordEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(response){
        var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.isSelfRegistrationEnabled',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(response){
        var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(response){
        var rtnValue = response.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communitySelfRegisterUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helpler) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(response){ });
            $A.enqueueAction(action);
        }
    }
})