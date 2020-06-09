//ObjectPluralName is the Action Object name. ObjectAPIName is the API Name of the object to process.
trigger Resultado on VN_Resultado__c (after delete, after insert, after update, before delete, before insert, before update){
  
  if(Trigger.isAfter){
    if(Trigger.isInsert){
        FieloPLT.SObjectService.processRecords(Trigger.new, null);  
    }else if(Trigger.isUpdate){
        FieloPLT.SObjectService.processRecords(Trigger.new, Trigger.oldMap);
    }
  }
  
}