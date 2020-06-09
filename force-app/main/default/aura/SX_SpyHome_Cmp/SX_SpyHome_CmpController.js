({
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    changeButton: function (cmp, event) {
    	$('.component-accordion-button-text').toggleClass('d-none');
    	if ($('.component-accordion-header-button-icon').hasClass('fa-angle-down')) {
    		$('.component-accordion-header-button-icon').removeClass('fa-angle-down');
    		$('.component-accordion-header-button-icon').addClass('fa-angle-up');
    	} else {
    		$('.component-accordion-header-button-icon').removeClass('fa-angle-up');
    		$('.component-accordion-header-button-icon').addClass('fa-angle-down');
    	}
    },
    openAgreement : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'spy'});
        modalEvent.fire();
    },
    openTeamPerformance : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "SpyTeamPerformance", "type" : 'spy'});
        modalEvent.fire();
    },
    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
        action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue()); 
            helper.loadBadgesElite(component, event); 
            helper.loadBadgesYouBet(component, event); 
            helper.loadBadgesEngajamento(component, event); 
        });
        $A.enqueueAction(action);
    },
})