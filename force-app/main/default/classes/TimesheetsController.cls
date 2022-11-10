public with sharing class TimesheetsController {
   

    @AuraEnabled(cacheable=true)
    public static List<Time_Sheet__c> getRelatedTimesheets(Id projectId){
        try{
            return [SELECT Id, Name, Status__c, Rejection_Count__c
                    FROM Time_Sheet__c
                    WHERE Project__c =:projectId
                    ORDER BY  CreatedDate ASC];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static void approveOrRejectTimesheets(List<Time_Sheet__c> timesheetsToApproveOrReject, String actiontype){

        System.debug('Action Type : '+actiontype);

        // Code to approve Timesheets
        if(actiontype.equals('approve')){
            try{
                for(Time_Sheet__c ts: timesheetsToApproveOrReject){
                    ts.Status__c = 'Approved';
                }
    
                update timesheetsToApproveOrReject;
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }

        }
        // Code to reject Timesheets
        else if(actiontype.equals('reject')){
            try{
                for(Time_Sheet__c ts: timesheetsToApproveOrReject){
                    ts.Status__c = 'Rejected';
                }
    
                update timesheetsToApproveOrReject;
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }

        }       
    }

   

}