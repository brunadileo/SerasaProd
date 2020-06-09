({
	myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
        action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());
            helper.loadDadosMeta(component, event);
            helper.loadVagas(component, event); 
            helper.loadRanking(component, event); 
            helper.loadPosicaoRanking(component,event);
        });
        $A.enqueueAction(action);
    },
    
	openAgreement : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'elite'});
        modalEvent.fire();
     },

    openExceedLimits : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
       modalEvent.setParams({"name" : "ExceedLimits", "type" : 'elite'});
       console.log('openExceed');
       modalEvent.fire();
    },
     
    openUnfinishedNotes : function(component, event, helper){
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "NotasEmAberto", "type" : 'elite'});
        modalEvent.fire();
    },

    openRanking : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
       modalEvent.setParams({"name" : "Ranking", "type" : 'elite'});
       modalEvent.fire();
    },
    
    openTeamPerformance : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"type" : 'elite', name:"EliteTeamPerformance"});
        modalEvent.fire();
    }
})