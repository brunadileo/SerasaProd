({
	youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'SpyTeamPerformance') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        helper.loadResultados(component, event); 
        $('#spyTeamPerformanceModal').show(200);
    },
    closeModal : function (component, event, helper) {
        $('#spyTeamPerformanceModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }
        component.set("v.tabelaBadges",null);
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());   
            helper.loadArea(component);
            helper.loadSubArea(component);
            helper.loadBadges(component);  
           // helper.loadResultados(component, event);   
        });
        $A.enqueueAction(action);
    },
    loadResultados : function(component, event, helper) {
        helper.loadResultados(component, event); 
    }
})