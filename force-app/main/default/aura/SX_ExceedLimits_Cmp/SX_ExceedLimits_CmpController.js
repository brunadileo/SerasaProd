({
    youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'ExceedLimits') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        $('#exceedlimitsModal').show(200);
    },
    closeModal : function (component, event, helper) {
        $('#exceedlimitsModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }
    }
})