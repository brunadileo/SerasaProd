/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 03/08/2018
* 
* Name: VN_PhotoUploadControllerTest.cls
* 
* Classe de teste do VN_PhotoUploadController.cls
*
*******************************************************************************/
@isTest
private class VN_PhotoUploadControllerTest
{
  @isTest
  static void uploadSemId() {

    FieloPLT__Program__c lProg = SObjectForTest.getProgram('Test');
    insert lProg;

            
    Profile lPerfil = SObjectForTest.getProfile('Fielo Partner Community');
                        
    Account lAccount = SObjectForTest.getAccount();
    insert lAccount;

    Contact lContact = SObjectForTest.getContact();
    lContact.AccountId = lAccount.Id;
    insert lContact;

    User lUser = SObjectForTest.getUser(lPerfil.Id);
    lUser.ContactId = lContact.Id;
    insert lUser;

    FieloPLT__Member__c lMember = SObjectForTest.getMember(lProg.Id);
    insert lMember;

    Account lFornecedor = SObjectForTest.getAccount();
    insert lFornecedor;

    FieloPLT__Reward__c lRew = SObjectForTest.getReward(lProg.Id, lFornecedor.Id);
    lRew.Iniciativa__c = Label.V_IniciativaComplementar;
    lRew.V_PapelYoubet__c = 'LÍDERES';
    insert lRew;


    VN_PhotoUploadController lCTR = new VN_PhotoUploadController();
    lCTR.saveRecordField = true;
    lCTR.attField = 'FieloPLT__Image__c';
    lCTR.photoName = 'banner';
    lCTR.contentType = 'qq coisa';
    String lDoc = lCTR.docURL;
    String lImg = lCTR.getImageId( 'www.salesforce.com?QualquerEndereco=erro&id=' + lRew.id );
    String lOrg = lCTR.orgId;
    lCTR.photoBase64 =  'foto.png;image/png';
    lCTR.objAPIName = 'Contact';
    lCTR.objectName = 'Contact';
    lCTR.objectLabel = 'Contact';
    lCTR.recordId = lRew.id;
    lCTR.imgId = lRew.id;
    lCTR.lastMod = '';
    PageReference lPage = lCTR.deletePhoto();
    lPage = lCTR.cancelEdit();
    lCTR.changePhoto();

    String lURL = lCTR.createURL( lRew );
    lCTR.changePhoto();
    lCTR.photoBase64 = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQ';
    lCTR.getImageId( '' );
    lCTR.changePhoto();
    lCTR.cancelEdit();
    lCTR.deletePhoto();

    SObject lAux = (FieloPLT__Member__c) lMember;
    lCTR.record = lAux;
    boolean lHas = lCTR.hasImg;
    SObject lObj = lCTR.getImage();
    String lEnc = lCTR.getEncImage();
    lCTR.uploadAction();
    lCTR.getImage();

    lMember.FieloPLT__Image__c = '/servlet/servlet.ImageServer?id=null&oid=nullx&LastModifiedDate=null';
    update lMember;    
    lAux = (FieloPLT__Member__c) lMember;
    lCTR.record = lAux;
    lHas = lCTR.hasImg;
    lObj = lCTR.getImage();
    lEnc = lCTR.getEncImage();
    lCTR.uploadAction();
    lCTR.getImage();
  }

  @isTest
  static void uploadComId()
  {
    //Insert Program
    FieloPLT__Program__c lProgram = SObjectForTest.getProgram('Test');
    insert lProgram;

    VN_PhotoUploadController lPhotoUploadController = new VN_PhotoUploadController();
    lPhotoUploadController.saveRecordField = true;
    lPhotoUploadController.attField = 'FieloPLT__RewardInjectQuery__c';
    lPhotoUploadController.photoName = 'banner';
    lPhotoUploadController.contentType = 'qq coisa';
    String lDoc = lPhotoUploadController.docURL;
    String lImg = lPhotoUploadController.getImageId( 'www.salesforce.com?QualquerEndereco=erro&id=' + lProgram.id );
    String lOrg = lPhotoUploadController.orgId;
    lPhotoUploadController.photoBase64 =  'foto.png;image/png';
    lPhotoUploadController.objAPIName = 'FieloPLT__Program__c';
    lPhotoUploadController.objectName = 'FieloPLT__Program__c';
    lPhotoUploadController.objectLabel = 'FieloPLT__Program__c';
    lPhotoUploadController.recordId = lProgram.id;
    lPhotoUploadController.imgId = lProgram.id;
    lPhotoUploadController.lastMod = '';
    PageReference lPage = lPhotoUploadController.deletePhoto();
    lPage = lPhotoUploadController.cancelEdit();
    lPhotoUploadController.changePhoto();

    String lURL = lPhotoUploadController.createURL(lProgram);
    lPhotoUploadController.changePhoto();
    lPhotoUploadController.photoBase64 = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQ';
    lPhotoUploadController.getImageId( '' );
    lPhotoUploadController.changePhoto();
    lPhotoUploadController.cancelEdit();
    lPhotoUploadController.deletePhoto();

    
    lPhotoUploadController.record = (FieloPLT__Program__c) lProgram;
    boolean lHas = lPhotoUploadController.hasImg;
    SObject lObj = lPhotoUploadController.getImage();
    String lEnc = lPhotoUploadController.getEncImage();
    lPhotoUploadController.uploadAction();
    lPhotoUploadController.getImage();
  }
}