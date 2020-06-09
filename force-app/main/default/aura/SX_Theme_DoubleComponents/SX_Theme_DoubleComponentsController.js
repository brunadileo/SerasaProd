({
	showMyExtract : function(component, event, helper) {
		if($(".teamExtract").hasClass("disabled")) {
			$(".teamExtract").toggleClass("disabled");
			$(".myExtract").toggleClass("disabled");
			$("#content1").toggleClass("d-none");
			$("#content1").toggleClass("d-block");
			$("#content2").toggleClass("d-block");
		}
	},
	showTeamExtract : function(component, event, helper) {
		if($(".myExtract").hasClass("disabled")) {
			$(".myExtract").toggleClass("disabled");
			$(".teamExtract").toggleClass("disabled");
			$("#content1").toggleClass("d-block");
			$("#content1").toggleClass("d-none");
			$("#content2").toggleClass("d-block");
		}
	}
})