({
	redirect : function(papelYoubet, papelElite, papelSpy) {

		var currentPage = window.location.pathname;
		var naoElegivel = 'NÃO ELEGÍVEL';

       //se participante não for elegível ma campanha, redireciona pra home
		if ( (currentPage.toLowerCase().indexOf('youbet-home') >= 0 && papelYoubet == naoElegivel) 
				|| (currentPage.toLowerCase().indexOf('elite-home') >= 0 && papelElite == naoElegivel) 
				|| (currentPage.toLowerCase().indexOf('sales-person-of-the-year-home') >= 0 && papelSpy == naoElegivel)){

			window.location.href = './';
		} 
	}
})