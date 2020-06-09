({
	errorModal : function(component, event, helper) {
        component.set("v.msg", event.getParam("msg"));
        component.set("v.tipo", event.getParam("tipo"));
        console.log('msg: '+component.get("v.tipo")+'---'+component.get("v.msg"));
        $('#modalError').fadeIn(200);
    },

    closeModalError : function (component, event, helper) {
        $('#modalError').fadeOut(200);
       // location.reload();
    }
})