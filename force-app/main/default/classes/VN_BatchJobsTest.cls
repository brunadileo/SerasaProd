/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: VN_BatchJobsTest.cls
* 
* Classe de testes para a classe VN_BatchJobs.cls
*******************************************************************************/
@isTest
public with sharing class VN_BatchJobsTest {
	static testMethod void VN_BatchJobsTest(){

		Test.startTest();
            VN_BatchJobs lController = new VN_BatchJobs(); 
            lController.fExecutarActionPooler = true;  
            lController.getBatchJobs();
            VN_BatchJobs.BatchJob lBt = new VN_BatchJobs.BatchJob();
        Test.stopTest();	
	}
}