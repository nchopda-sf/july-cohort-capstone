public with sharing class RemoveTrainingTasksController {

    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getTrainingTasks(Id programId){

        Set<Id> alreadtTTList = new Set<Id>();
        List<Program_Task__c> alreadyPTList = [SELECT Id, Name, Program__c, Training_Task__c 
                                               FROM Program_Task__c 
                                               WHERE Program__c=:programId];

        for(Program_Task__c pt: alreadyPTList){
            alreadtTTList.add(pt.Training_Task__c);
        }
        
        try{
            return [SELECT Name, Task_type__c, Task_Length__c 
                    FROM Training_Task__c 
                    WHERE Id IN:alreadtTTList 
                    ORDER BY Task_type__c ASC];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }

    }

    
    @AuraEnabled
    public static void removeTrainingTasks(List<Training_Task__c> selectedTainingTasks, Id programId){

        List<Id> selectedTTIdList = new List<Id>();
        for(Training_Task__c stt: selectedTainingTasks){
            selectedTTIdList.add(stt.Id);
        }

        List<Program_Task__c> existingProgramTaskList = [SELECT Id, Name, Program__c, Training_Task__c, Days_to_Complete__c 
                                                         FROM Program_Task__c 
                                                         WHERE Program__c=:programId];
        
        List<Program_Task__c> ProgramTaskListtoremove = new List<Program_Task__c>();

        for(Program_Task__c epl : existingProgramTaskList){
            if(selectedTTIdList.contains(epl.Training_Task__c)){
                ProgramTaskListtoremove.add(epl);
            }
        }

        try{
            delete ProgramTaskListtoremove;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
       
    }
  
}