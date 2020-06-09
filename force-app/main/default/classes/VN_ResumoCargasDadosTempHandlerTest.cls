@isTest
private class VN_ResumoCargasDadosTempHandlerTest {

    @isTest
    static void test(){
        // Criar participantes, gerenciador de meta, meta, sumarizador, preencher sumarizador
        FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);

        List<VN_Sumarizador__c> lstSumarizador = new List<VN_Sumarizador__c>();
        lstSumarizador = [SELECT V_ProcessarCalculos__c
                    FROM VN_Sumarizador__c WHERE V_Mes__c = 1];

        for(VN_Sumarizador__c lSumarizador : lstSumarizador) {
            lSumarizador.V_ProcessarCalculos__c = true;          
        }
        update lstSumarizador;

        Test.startTest();
        VN_ResumoCargasDadosTemp__c rcd =  SObjectForTest.getResumoCargaDadosTemp();
        rcd.V_StatusPDI__c = 'Carregado';
        insert rcd;
        Test.stopTest();

        // check apex batch is in the job list
        List<AsyncApexJob> jobsApexBatch = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ApexClass.Name = 'SX_BatchAtualizarSumarizador'];
        System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
    }
}