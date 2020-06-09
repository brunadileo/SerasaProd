({
	youbetModal : function(component, event, helper) {
        component.set("v.lance", event.getParam("lance"));
        $('#modalSucess').fadeIn(200);
    },

    closeModal : function (component, event, helper) {
        $('#modalSucess').fadeOut(200);
        location.reload();
    }
})