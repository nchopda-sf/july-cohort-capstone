public with sharing class AssignTrainingTasksController {

    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getTrainingTasks(Id programId, String textkey){

        Set<Id> alreadtTTList = new Set<Id>();
        System.debug('Search Key : ' +textkey);
        textkey = '%' + textkey + '%';

        List<Training_Task__c> returnTrainingTaskList = new List<Training_Task__c>();

        List<Program_Task__c> alreadyPTList = [SELECT Id, Name, Program__c, Training_Task__c 
                                               FROM Program_Task__c 
                                               WHERE Program__c=:programId];
        for(Program_Task__c pt: alreadyPTList){
            alreadtTTList.add(pt.Training_Task__c);
        }
       /* try{
            return [SELECT Name, Task_type__c, Task_Length__c 
                    FROM Training_Task__c 
                    WHERE Id NOT IN:alreadtTTList 
                    ORDER BY Task_type__c ASC];

        }*/
      
        try{
            returnTrainingTaskList = [SELECT Name, Task_type__c, Task_Length__c 
            FROM Training_Task__c 
            WHERE Id NOT IN:alreadtTTList AND Name LIKE :textkey
            ORDER BY Task_type__c ASC];

            if(returnTrainingTaskList.isEmpty()){
                throw new AuraHandledException('No Record Found..');
            }

            return returnTrainingTaskList;
            
        } 
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled
    public static void insertTrainingTasks(List<Training_Task__c> selectedTainingTasks, List<Integer> daystoComplete,Id programId){

        List<Program_Task__c> newProgramTaskList = new List<Program_Task__c>();

        for(Integer i=0; i<selectedTainingTasks.size();i++){
            
            Program_Task__c pt = new Program_Task__c();
            pt.Training_Task__c = selectedTainingTasks.get(i).Id;
            pt.Program__c = programId;
            pt.Days_to_Complete__c = daystoComplete.get(i);
            newProgramTaskList.add(pt);

        }

        try{
            insert newProgramTaskList;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
       
    }
    
}