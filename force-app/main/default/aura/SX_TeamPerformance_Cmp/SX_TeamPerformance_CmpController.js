({
	youbetModal : function (component, event, helper) {
        if (event.getParam("name") != 'TeamPerformance') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        component.set("v.youbetType", event.getParam("type"));
        helper.loadResultados(component, event);
        $('#teamPerformanceModal').show(200);
    },

    closeModal : function (component, event, helper) {
        helper.doCloseModal(component, event);
        $('#teamPerformanceModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }
        component.set('v.area', "");
        component.set('v.subArea', "");
        component.set('v.cargo', "");
        component.find("palavraChave").set("v.value", "");
        component.set("v.tableCols", "");
        component.set("v.lstRdi",null);
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());   
            helper.loadArea(component);
            helper.loadSubArea(component);
            helper.loadCargo(component);   
        });
        $A.enqueueAction(action);
    },
    loadResultados : function(component, event, helper) {
        helper.loadResultados(component, event); 
    },
    searchOnEnter : function (component, event, helper) {
        if(event.getParams().keyCode == 13){
            helper.loadResultados(component, event);
        }
    }
})