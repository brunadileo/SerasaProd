/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: JNS                                                    date: 25/08/2017
* 
* Name: VN_PhotoUploadController.cls
* 
* Classe controladora para componente VN_PhotoUpload
*******************************************************************************/
public with sharing class VN_PhotoUploadController {

    //component attributes
    public SObject record {get; set{
                                record = value;
                                //makes a describe of the object to store information about it
                                Schema.DescribeSObjectResult objectDescription = record.getSObjectType().getDescribe();
                                //Set the record id
                                recordId = String.valueOf(record.get('Id'));
                                //set object label and name
                                objectLabel = String.valueOf(objectDescription.getLabel());
                                objectName = String.valueOf(objectDescription.getName());
                                record = Database.query('SELECT ' + attField + ' FROM ' + record.getSObjectType().getDescribe().getName() + ' WHERE Id = \'' + record.Id + '\'');
                            } }
    public Boolean saveRecordField {get; set;}
    public String attField {get; set;}
    public transient String contentType {get; set;}

    public String docURL{get{
        if(docURL == null){
                docURL = '';
            }
            return docURL;
        } set;}

    public String getImageId(String imgURL){
        if(imgURL == null || imgURL == '') return imgURL;
        String imageId;
        Integer startPosDoc = imgURL.indexOf('id=');
        if(startPosDoc != -1){
            imageId = imgURL.substring(startPosDoc+3, startPosDoc+21);
        }
        return imageId;
    }

    public String orgId{get{return UserInfo.getOrganizationId();}set;}//this is used in the component instead of using $Organization.Id directly in VisualForce because using the attribute the image can be cached

    //private attributes
    private transient Document currentDocument {get; set;}
    private transient Attachment currentAttachment {get; set;}
    private Set<String> imagesTypes = new Set<String> {'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'};
    private transient Attachment oldAttachment {get; set;}

    //public attributes
    public transient String photoBase64 {get; set;}
    public String objAPIName {get{if(objAPIName == null) objAPIName = record.getSObjectType().getDescribe().getName(); return objAPIName;} set;}
    public String error {get; set;}
    public Boolean editPhoto {get; set;}
    public String objectName {get; set;}
    public String objectLabel {get; set;}
    public Id recordId {get; set;}
    public String photoName {get; set;}
    public Boolean hasImg {get{if(image == null) getImage(); return hasImg;} set;}
    public String imgId {get; set;}
    public String lastMod {get; set;}//this attribute it's used to be appended at the end of the src of the img tag of HTML in the component, this ways any time an image is changed the previous image is not cached anymore

    public VN_PhotoUploadController(  ){

        error = '';
        editPhoto = false;
        //record = Database.query('SELECT ' + attField + ' FROM ' + record.getSObjectType().getDescribe().getName() + ' WHERE Id = \'' + record.Id + '\'');

        if (record != null && record.get(attField) != null){
            hasImg = true;
        }
    }

    public PageReference uploadAction(){

        if(validate()){
            if(saveCurrentPicture()){
                changePhoto();
                if(oldAttachment != null) {
                    try{
                        //SecurityUtils.checkObjectIsDeletable(Attachment.sObjectType);
                        delete oldAttachment;
                    } catch (Exception e){
                        e.getMessage();
                    }
                }
            }
        }
        hasImg = true;
        return null;
    }

    private Document getCurrentDocument(){

        record = Database.query('SELECT ' + attField + ' FROM ' + record.getSObjectType().getDescribe().getName() + ' WHERE Id = \'' + record.Id + '\'');

        if(record.get(attField) == null /*|| ((String)record.get(attField)).startsWith('/')*/){
            return null;
        }
        Document doc = [SELECT Id, Body, ContentType, LastModifiedDate FROM Document WHERE Id =: getImageId((String)record.get(attField)) LIMIT 1];
        imgId = doc.Id;
        lastMod = String.valueOf(doc.LastModifiedDate.Year()) + String.valueOf(doc.LastModifiedDate.month()) + String.valueOf(doc.LastModifiedDate.day()) + String.valueOf(doc.LastModifiedDate.hour()) + String.valueOf(doc.LastModifiedDate.minute()) + String.valueOf(doc.LastModifiedDate.second());
        return doc;
    }

    public String getEncImage(){
        String base64;
        if((String)record.get(attField) != null){
            if(getImageId((String)record.get(attField)).substring(0,3) == '015'){
                if(currentDocument == null){
                    currentDocument = getCurrentDocument();
                }
                base64 = EncodingUtil.Base64Encode(currentDocument.Body);
                contentType = currentDocument.ContentType;
                currentDocument.body = null;
            }
        }
        return base64;
    }

    public void changePhoto(){
        editPhoto = !editPhoto;
    }

    public PageReference cancelEdit(){
        editPhoto = !editPhoto;
        return null;
    }

    public PageReference deletePhoto(){
        try{
            if(saveRecordField){
                //attField
                record.put(attField,null);
                update record;
            }
            hasImg = false;
            imgId = null;
        }catch(Exception e){
           // ErrorService.insertError(e);
        }

        return null;
    }

    private sObject image;
    public sObject getImage(){

        image = new Document();
        String imageId = getImageId((String)record.get(attField));

        if((imageId != null) && (imageId.substring(0,3) == '015')){
            List<SObject> whereIsUsed = Database.query('SELECT Id FROM ' + record.getSObjectType().getDescribe().getName() + ' WHERE ' + attField + ' = \'' + record.get(attField) + '\' AND Id != \'' + record.Id + '\'');
            Boolean isUsed = !whereIsUsed.isEmpty();
            if(currentDocument == null){
                currentDocument = getCurrentDocument();
            }
            image = currentDocument;
            if(isUsed) image = currentDocument.clone(false, false, false, false);
            hasImg = false;
            if(image != null) hasImg = image.get('Body') != null;

        }

        return image;
    }

    private Boolean saveCurrentPicture(){
        Savepoint sp = Database.setSavepoint();

        if(photoBase64 != '' && photoBase64 != null) {
            Integer firstComma = photoBase64.indexOf(',');
            photoBase64 = photoBase64.substring(firstComma + 1, photoBase64.length() - 1);
            image.put('Body', EncodingUtil.Base64Decode(photoBase64));
        }


        lastMod = String.valueOf(Datetime.now().Year()) + String.valueOf(Datetime.now().month()) + String.valueOf(Datetime.now().day()) + String.valueOf(Datetime.now().hour()) + String.valueOf(Datetime.now().minute()) + String.valueOf(Datetime.now().second());
        if(image.Id != null){
            update image;
            image.put('body', null);
            updateAttachField(image);
        }else{
            image.put('Name', photoName);
            String folderId;
            Folder folder = [SELECT Id FROM Folder WHERE DeveloperName = 'VN_BadgeSX'];
            folderId = folder.Id;
            image.put('FolderId', folderId);
            image.put('IsPublic', true);
            upsert image;
            image.put('body', null);

            imgId = image.Id;
            updateAttachField(image);
        }
        return true;
    }

    private void updateAttachField(sObject attachRecord){
        if(saveRecordField){
            sObject recordQuery = Database.query('SELECT ' + attField + ' FROM ' + objectName + ' WHERE Id =: recordId');
            recordQuery.put(attField, createURL(attachRecord));
            update recordQuery;
        }
    }

    private Boolean validate(){
        try{
            if(photoBase64 != '' && photoBase64 != null) {
                    image.put('ContentType', photoBase64.substring(photoBase64.indexOf(':')+1, photoBase64.indexOf(';')));
            }
            Boolean ret = true;
            this.error = '';

            if(!imagesTypes.contains((String)image.get('ContentType'))){
                ret = false;
            }
            return ret;
        } catch (Exception e) {
            return false;
        }
    }

    public String createURL(sObject imageRecord){
        String url;
        if(((String)imageRecord.Id).substring(0, 3) == '015'){
            url = '/servlet/servlet.ImageServer?id=' + (String)imageRecord.Id + '&oid=' + UserInfo.getOrganizationId() + '&LastModifiedDate=' + String.valueOf(imageRecord.get('LastModifiedDate'));

        }
        return url;
    }

}