({
	youbetModal : function(cmp, event, helper) {
        if (event.getParam("type") != 'AlertBets') return;
        console.log(event.getParam("type"));
        $('#alertBetsModal').fadeIn(200);
    },

    closeModal : function (cmp, event, helper) {
        $('#alertBetsModal').fadeOut(200);
    }
})