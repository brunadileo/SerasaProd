/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 11/09/2018
* 
* Name: SX_ProcessamentosController.cls
* 
* Classe qua alimenta a page SX_Processamentos
*******************************************************************************/
public with sharing class SX_ProcessamentosController {

    final private String VALIDACAO_MES_ANO = 'É necessário preencher o Mês e o Ano Fiscal para possibilitar esse processamento';
    final private String VALIDACAO_ANO = 'É necessário preencher o Ano Fiscal para possibilitar esse processamento';
    final private String VALIDACAO_SEM_VIGENCIA = 'Não encontamos Metas vigentes para realizar o cálculo';
    private String PRIMEIRO = 'Primeiro';
    private String SEGUNDO = 'Segundo';
    private String TERCEIRO = 'Terceiro';
    private String QUARTO = 'Quarto';
    private String QUINTO = 'Quinto';
    private String SEXTO = 'Sexto';
    private String SETIMO = 'Setimo';
    private String OITAVO = 'Oitavo';
    private String NONO = 'Nono';
    private String DECIMO = 'Decimo';
    public static String DECIMO_PRIMEIRO = 'DecimoPrimeiro';
    public static String DECIMO_SEGUNDO = 'DecimoSegundo';

    public String fMesCalculos {get; set;}
    public String fMesMecanica {get; set;}

    public Boolean fProcessarCalculos {get; set;}
    public Boolean fProcessarAnoFiscal {get; set;}
    public Boolean fProcessarMecanica {get; set;}
    public Boolean fProcessarLanceGanhador {get; set;}
    public Boolean fProcessarSumarizadores {get; set;}


    public String fAnoFiscal {
        get{
            List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
                                                                FROM VN_GerenciadorMetaParticipanteAF__c
                                                                WHERE V_Vigente__c = true];
            return !lLstGeren.isEmpty() ? lLstGeren[0].V_AnoFiscal__c : '-';
        } 
        set;
    }  

    public SX_ProcessamentosController(){

        fProcessarCalculos = false;
        fProcessarAnoFiscal = false;
        fProcessarMecanica = false;
        fProcessarLanceGanhador = false;
        fProcessarSumarizadores = false;
    }

    public void processarCalculos(){

        if(String.isEmpty(fAnoFiscal) || String.isEmpty(fMesCalculos)){
            SX_Utils.addError(VALIDACAO_MES_ANO);
            return;
        }

        SX_BatchProcessarCalculos lBatch = new SX_BatchProcessarCalculos(fAnoFiscal, Integer.valueOf(fMesCalculos)); 
        Database.executeBatch(lBatch); 
        fMesCalculos = '';
        fProcessarCalculos = true;
    }

    public void processarAnoFiscalConcluido(){

        //if(String.isEmpty(fAnoFiscal)){
        //  SX_Utils.addError(VALIDACAO_ANO);
        //  return;
        //}

        //List<AggregateResult> lLstAgg =  [SELECT COUNT(Id) total
        //                  FROM VN_MetasParticipantes__c
        //                  WHERE Name =: fAnoFiscal
        //                  AND V_ProcessarCalculosDecimoSegundoMesAF__c = false];
        //Integer lTotal = lLstAgg != null ? Integer.valueOf(lLstAgg[0].get('total')) : 0; 
        //if(lTotal > 0){
        //  SX_Utils.addError(Label.V_MensagemAnoFiscal12Mes);
        //  return;
        //}

        //SX_BatchAnoFiscalConcluido lBatch = new SX_BatchAnoFiscalConcluido(fAnoFiscal); 
  //      Database.executeBatch(lBatch); 
  //      fProcessarAnoFiscal = true;
    }

    public void processarMecanica(){

        if(String.isEmpty(fAnoFiscal) || String.isEmpty(fMesMecanica)){
            SX_Utils.addError(VALIDACAO_MES_ANO);
            return;
        }
        Integer lMes = Integer.valueOf(fMesMecanica);

        // String lQuery = 'SELECT COUNT(Id) total '+
        //              'FROM VN_MetasParticipantes__c '+
        //              'WHERE Name = \''+ fAnoFiscal+'\' '+
        //              'AND V_ProcessarCalculos' + fMesMecanica + 'MesAF__c = false';

        // Nova estrutura
        String lQuery = 'SELECT COUNT(Id) total '+
                        'FROM VN_Sumarizador__c '+
                        'WHERE V_MetaDoParticipante__r.Name = \'' + fAnoFiscal +'\' '+
                        'AND V_Mes__c = ' + lMes +
                        ' AND V_ProcessarCalculos__c = false';

        List<AggregateResult> lLstAgg =  (list<AggregateResult>) Database.query(lQuery);
        Integer lTotal = lLstAgg != null ? Integer.valueOf(lLstAgg[0].get('total')) : 0; 
        if(lTotal > 0){
            SX_Utils.addError(Label.V_MensagemProcessarMecanica);
            return;
        }

        //SX_BatchProcessarMecanica lBatch = new SX_BatchProcessarMecanica(fAnoFiscal, fMesMecanica);
        SX_BatchProcessarMecanica lBatch = new SX_BatchProcessarMecanica(fAnoFiscal, lMes);
        Database.executeBatch(lBatch, 2); 
        fProcessarMecanica = true;
    }

    public void processarLanceGanhador(){

        SX_BatchLanceGanhador lBatch = new SX_BatchLanceGanhador(); 
        Database.executeBatch(lBatch); 
        fProcessarLanceGanhador = true;
    }

    public void processarSumarizadores(){
        Database.executeBatch(new SX_BatchAtualizarSumarizador());
        fProcessarSumarizadores = true;
    }


    public  List<SelectOption> getMesDesejado() { 
        // List<SelectOption> lLstOption = new List<SelectOption>();
        // lLstOption.add(new SelectOption('', 'Selecione'));
        // lLstOption.add(new SelectOption(PRIMEIRO, Label.V_PrimeiroMes));
        // lLstOption.add(new SelectOption(SEGUNDO, Label.V_SegundoMes));
        // lLstOption.add(new SelectOption(TERCEIRO, Label.V_TerceiroMes));
        // lLstOption.add(new SelectOption(QUARTO, Label.V_QuartoMes));
        // lLstOption.add(new SelectOption(QUINTO, Label.V_QuintoMes));
        // lLstOption.add(new SelectOption(SEXTO, Label.V_SextoMes));
        // lLstOption.add(new SelectOption(SETIMO, Label.V_SetimoMes));
        // lLstOption.add(new SelectOption(OITAVO, Label.V_OitavoMes));
        // lLstOption.add(new SelectOption(NONO, Label.V_NonoMes));
        // lLstOption.add(new SelectOption(DECIMO, Label.V_DecimoMes));
        // lLstOption.add(new SelectOption(DECIMO_PRIMEIRO, Label.V_DecimoPrimeiroMes));
        // lLstOption.add(new SelectOption(DECIMO_SEGUNDO, Label.V_DecimoSegundoMes));
        // return lLstOption;

        //Nova estrutura
        List<SelectOption> lLstOption = new List<SelectOption>();
        lLstOption.add(new SelectOption('', 'Selecione'));
        lLstOption.add(new SelectOption('1', Label.V_PrimeiroMes));
        lLstOption.add(new SelectOption('2', Label.V_SegundoMes));
        lLstOption.add(new SelectOption('3', Label.V_TerceiroMes));
        lLstOption.add(new SelectOption('4', Label.V_QuartoMes));
        lLstOption.add(new SelectOption('5', Label.V_QuintoMes));
        lLstOption.add(new SelectOption('6', Label.V_SextoMes));
        lLstOption.add(new SelectOption('7', Label.V_SetimoMes));
        lLstOption.add(new SelectOption('8', Label.V_OitavoMes));
        lLstOption.add(new SelectOption('9', Label.V_NonoMes));
        lLstOption.add(new SelectOption('10', Label.V_DecimoMes));
        lLstOption.add(new SelectOption('11', Label.V_DecimoPrimeiroMes));
        lLstOption.add(new SelectOption('12', Label.V_DecimoSegundoMes));
        return lLstOption;
    }
    
    public void recalcularRanking(){

        List<VN_MetaParticipante__c> metas = [SELECT Name FROM VN_MetaParticipante__c where V_ParticRankingElite__c = true];
        Set<String> lSetAnoFiscal = new Set<String>();
    
        for (VN_MetaParticipante__c meta : metas) {
            lSetAnoFiscal.add(meta.Name);
        }

        if(!lSetAnoFiscal.isEmpty()){
            Decimal lRandomNumber = Integer.valueof((Math.random() * 1000000));
            System.scheduleBatch ( new SX_BatchAtualizarRankingNaMeta(lSetAnoFiscal),'Atualizar posição ranking '+lRandomNumber, 1); 
        }
    }
}