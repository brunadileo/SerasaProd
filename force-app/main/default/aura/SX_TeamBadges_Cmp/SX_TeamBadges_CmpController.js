({
	closeModal : function (component, event, helper) {
        helper.doCloseModal(component, event);
        $('#teamBadges').hide(200);
        component.set('v.area', "");
        component.set('v.subArea', "");
        component.set('v.badge', "");
        component.find("palavraChave").set("v.value", "");
        component.set("v.tableCols", "");
        component.set("v.lstRdi",null);
    }
})