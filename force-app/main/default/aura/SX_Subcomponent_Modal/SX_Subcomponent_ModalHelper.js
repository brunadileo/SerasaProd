({
	closeModalAfterClick : function(component, event, helper) {
		$('.modal-overlay').fadeTo(0, 0).delay(0).queue(function() {
         	$('.modal-overlay').removeClass('d-block').addClass('d-none').dequeue();
    	});
    	debugger;
    	if (nextStepClicked) {

		} else {

		}
	}
})