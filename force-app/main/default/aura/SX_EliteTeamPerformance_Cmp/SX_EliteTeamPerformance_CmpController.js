({
	youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'EliteTeamPerformance') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
       // helper.loadResultados(component, event); 
        $('#eliteTeamPerformanceModal').show(200);
    },
    closeModal : function (component, event, helper) {
        $('#eliteTeamPerformanceModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());  
            helper.loadPapel(component);  
            helper.loadArea(component);
            helper.loadSubArea(component);
            helper.loadCargo(component);    
        });
        $A.enqueueAction(action);
    },
    loadResultados : function(component, event, helper) {
        helper.loadResultados(component, event); 
    }
})