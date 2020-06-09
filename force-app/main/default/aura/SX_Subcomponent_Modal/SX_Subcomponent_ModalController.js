({
	nextStep : function(component, event, helper) {
		$('#newPw').fadeOut(200).queue(function() {
			$('#nickname').fadeIn(200);
		})
	},

	openModal : function(component, event, helper) {
		var attFunction = component.get("v.function");
		component.set("v.function", event.getParam("function"));
		component.set("v.numeroRegistro", event.getParam("numeroRegistro"));
		$('#subModalDiv').fadeIn(200);
	}, 

	closeModal : function(component, event, helper) {
  		$('#subModalDiv').fadeOut(200);
  		component.find("email").set("v.value", "");
	},

	setNickname : function(component, event, helper) {
		var nickname = component.find('nickname').get('v.value');
		var password = component.find('confirmPassword').get('v.value');
		var numeroRegistro = component.get('v.numeroRegistro');

		var action = component.get('c.setNickname1');
		var param = new Object();
		param.numeroRegistro = numeroRegistro;
		param.nickname = nickname;
		param.password = password;
		//console.log(param);
		action.setParams(param);
        action.setCallback(this, function(response){
            var returnValue = response.getReturnValue();
            if (returnValue !== null) {
                component.set("v.errorMessage",returnValue);
                component.set("v.showError",true);
            }
        });
        $A.enqueueAction(action);
	},

	forgotPassword : function(component, event, helper) {
		var email = component.find('email').get('v.value');

		var action = component.get('c.doForgotPassword');
		var param = new Object();
		param.numeroRegistro = email;

		action.setParams(param);
        action.setCallback(this, function(response){
            var returnValue = response.getReturnValue();
            component.find("email").set("v.value", "");
             $('.modal-overlay').fadeOut(0);
            if (returnValue !== null) {
            	var alerta = $A.get("e.c:SX_Alert_Evt");
            	alerta.setParams({"msg" : "Registro não encontrado.", "tipo": "error"}).fire();
            } else {
            	var alerta = $A.get("e.c:SX_Alert_Evt");
            	alerta.setParams({"msg" : "Email enviado com sucesso.", "tipo": "success"}).fire();
            	
            }
        });
        $A.enqueueAction(action);
	}

})