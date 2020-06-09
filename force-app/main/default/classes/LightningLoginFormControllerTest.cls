@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

	@IsTest
	static void testLoginWithInvalidCredentials() {
		//User lUser = SObjectForTest.loadUserLoggedMember();
 	//	System.assertEquals('Usuário não encontrado', LightningLoginFormController.login('testUser', 'fakepwd', null));
 	//	System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login(lUser.Username, 'fakepwd', null));
	}

 	@IsTest
 	static void testForgotPasswordInvalidUser() {
  		System.assertEquals(Label.Site.invalid_email, LightningLoginFormController.forgotPassword('',''));
 	}

 	@IsTest
 	static void setExperienceId(){
 		String lEmptyString;
 		System.assertEquals(null, LightningLoginFormController.setExperienceId(lEmptyString));
 		System.assertEquals('Esse método pode ser chamado somente de dentro de uma comunidade.', LightningLoginFormController.setExperienceId('test'));
 	}

 	@IsTest
 	static void getForgotPasswordUrl(){
 //		System.assertEquals(null, LightningLoginFormController.getForgotPasswordUrl());
 	}

 	@IsTest
 	static void LightningLoginFormControllerInstantiation() {
  		LightningLoginFormController controller = new LightningLoginFormController();
  		System.assertNotEquals(controller, null);
 	}

 	@IsTest
 	static void testIsUsernamePasswordEnabled() {
  		//System.assertEquals(false, LightningLoginFormController.getIsUsernamePasswordEnabled());
 	}

 	@IsTest
 	static void testIsSelfRegistrationEnabled() {
  		System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
	}

 	@IsTest
 	static void testGetSelfRegistrationURL() {
  		System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 	}

 	@IsTest
 	static void testAuthConfig() {
  		Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  		System.assertNotEquals(null, authConfig);
 	}
}