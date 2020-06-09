/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: VN_BatchJobs.cls
* 
* Controller do componente de status do Batch
*******************************************************************************/
public with sharing class VN_BatchJobs {

	public Boolean fExecutarActionPooler {get; set;}
	public String fErros {get; set;}

	public String fNameBatch {get;
        set {
            if (fNameBatch != null) {
                return;
            }
            fNameBatch = value;
        }
    }

	public List<BatchJob> fBatchJobs;

	public VN_BatchJobs() { }

	 public List<BatchJob> getBatchJobs(){   

	    fBatchJobs = new List<BatchJob>();    
        
        List<AsyncApexJob> lListJobs = new List<AsyncApexJob>();
        lListJobs.add(getJob(fNameBatch));
        
                                                            
        for(AsyncApexJob a : lListJobs){
            if( a == null ) continue;
            Double itemsProcessed = a.JobItemsProcessed;
            Double totalItems = a.TotalJobItems;
    
            BatchJob j = new BatchJob();
            j.job = a;
            //Determine the pecent complete based on the number of batches complete
            if(totalItems == 0){
                //A little check here as we don't want to divide by 0.
                j.percentComplete = 0;
            }else{
                j.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
            }

            j.acao = fNameBatch; 
            
            fExecutarActionPooler = true;
            if ( a.Status == 'Completed' || a.Status == 'Aborted' || a.Status == 'Failed' )
                fExecutarActionPooler = false;
  
            fBatchJobs.add(j);  
        }       

        if(!fExecutarActionPooler){
            wait();
        	List<VN_LogBatch__c> lLstLog = [SELECT Id FROM VN_LogBatch__c WHERE V_IdBatch__c =: fBatchJobs[0].job.ParentJobId];
			fErros = lLstLog.isEmpty() ? '' : lLstLog[0].Id;
        }
        
        return fBatchJobs;
    }

    private void wait(){
        Long startingTime = System.now().getTime(); 
        Integer delayInMilliseconds = 3000; 
        while (System.now().getTime() - startingTime < delayInMilliseconds)  {
        }
    }

	private AsyncApexJob getJob(String aName){
        
       List<AsyncApexJob> lLstBatchs = [SELECT Id, ApexClass.Name,TotalJobItems,JobItemsProcessed , Status,CompletedDate, ParentJobId
                                  FROM AsyncApexJob 
                                  WHERE ApexClass.Name =: aName
                                  ORDER BY  CreatedDate DESC LIMIT 1];  

        return lLstBatchs.isEmpty() ? null : lLstBatchs[0];
    }

	public class BatchJob{

        public AsyncApexJob job {get; set;}
        public Integer percentComplete {get; set;}
        public String acao {get; set;}
        public String colorStatus {get;set;}
    
        public BatchJob(){
            this.job=null;
            this.percentComplete=0;
            this.acao = '';
            this.colorStatus = '';
        }
    }
}