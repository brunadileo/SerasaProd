({
	myAction : function(component, event, helper) {
		
	},
	// handleClick: function (cmp, event) {
	// 	cmp.set('v.loaded', !cmp.get('v.loaded'));
 //    }

 	loadingControl : function(component, event, helper) {
 		var lType = event.getParam("type");
 		if (lType == 'Open') {
 			component.set(v.loaded, false);
 		} else {
 			component.set(v.loaded, true);
 		}
 	}
})