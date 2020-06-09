// /*******************************************************************************
// *                          Copyright (C) 2019 ValueNET
// * ------------------------------------------------------------------------------
// * Author: LK                          date: 18/07/2019
// * 
// * Name: SX_SumarizadorTrigger.cls
// * 
// * Classe para disparar ações do VN_Sumarizador
// *******************************************************************************/
public with sharing class SX_SumarizadorTrigger {
//     public static Set<Integer> fMesProcessado;
//     public static Set<Integer> fMesesAnteriores;
//     public static final Integer MES_6 = 6;
//     public static final Integer MES_9 = 9;
//     public static final Integer MES_12 = 12;
//     public static final Set<Integer> SET_PRIMEIROSEMESTRE = new Set<Integer> {1, 2, 3, 4, 5, 6};
//     public static final Set<Integer> SET_SEGUNDOSEMESTRE = new Set<Integer> {7, 8, 9, 10, 11, 12};
//     public static final Set<Integer> SET_SEGUNDOTRIMESTRE = new Set<Integer> {4, 5, 6};
//     public static final Set<Integer> SET_TERCEIROTRIMESTRE = new Set<Integer> {7, 8, 9};
//     public static final Set<Integer> SET_QUARTOTRIMESTRE = new Set<Integer> {10, 11, 12};

//     public static Set<Id> fSetSumarizador;

//     public static void atualizarSumarizador(){

//         List<VN_Sumarizador__c> lstSumarizadores = (List<VN_Sumarizador__c>) Trigger.new;
//         if(fSetSumarizador == null){
//             fSetSumarizador = new Set<Id>();
//         }

//         if(!system.isBatch()){
        
//             Map<Id, VN_Sumarizador__c> lMapSumarizadorMaisAntigo = new Map<Id, VN_Sumarizador__c>();
//             for(VN_Sumarizador__c lSumarizador : lstSumarizadores){
//                 if(fSetSumarizador.contains(lSumarizador.Id))
//                     continue;
//                 else
//                     fSetSumarizador.add(lSumarizador.Id);

//                 if(!lMapSumarizadorMaisAntigo.containsKey(lSumarizador.V_MetaDoParticipante__c))
//                     lMapSumarizadorMaisAntigo.put(lSumarizador.V_MetaDoParticipante__c, lSumarizador);
//                 else{
//                     if(lMapSumarizadorMaisAntigo.get(lSumarizador.V_MetaDoParticipante__c).V_Mes__c 
//                             > lSumarizador.V_Mes__c){
//                         lMapSumarizadorMaisAntigo.put(lSumarizador.V_MetaDoParticipante__c, lSumarizador);
//                     }
//                 }    
//             }
//             if(!lMapSumarizadorMaisAntigo.isEmpty()){
//                 SX_BatchAtualizarSumarizador lBatch = new SX_BatchAtualizarSumarizador(lMapSumarizadorMaisAntigo.values()); 
//                 Database.executeBatch(lBatch);
//             }
//         }
//     }
}