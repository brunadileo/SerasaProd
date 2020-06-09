({
    youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'Ranking') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        component.set("v.youbetType", event.getParam("type"));
        $('#RankingModal').show(200);
    },

    closeModal : function (component, event, helper) {
        $('#RankingModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }

    },

    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());
            helper.loadRanking(component, event);
            helper.loadUltimoMesProcessado(component, event);
        });
        $A.enqueueAction(action); 
    }
})