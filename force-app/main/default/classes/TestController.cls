public with sharing class TestController {

    @AuraEnabled(cacheable=true)
    public static List<Training_Task__c> getTrainingTasks(Id programId){

        System.debug('Inside getTrainingTasks : Program Id : '+programId);
        Set<Id> alreadtTTList = new Set<Id>();
        List<Program_Task__c> alreadyPTList = [SELECT Id, Name, Program__c, Training_Task__c 
                                               FROM Program_Task__c 
                                               WHERE Program__c=:programId];
        for(Program_Task__c pt: alreadyPTList){
            alreadtTTList.add(pt.Training_Task__c);
        }
        System.debug('Inside getTrainingTasks : List Size : '+alreadyPTList.size());
        try{
            return [SELECT Name, Task_type__c, Task_Length__c 
                    FROM Training_Task__c 
                    WHERE Id NOT IN:alreadtTTList 
                    ORDER BY Task_type__c ASC];
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }

    }

    
    @AuraEnabled
    public static void insertTrainingTasks(List<Training_Task__c> selectedTainingTasks, List<Integer> daystoComplete,Id programId){

        System.debug('Inside Insert Method');
        System.debug('Program Id : '+programId);
        System.debug('List of Selected Training Tasks + '+selectedTainingTasks);
        System.debug('daystoComplete + '+daystoComplete);

        List<Program_Task__c> newProgramTaskList = new List<Program_Task__c>();

        System.debug('Starting of for loop');
        for(Integer i=0; i<selectedTainingTasks.size();i++){
            System.debug(selectedTainingTasks.get(i));
            System.debug(daystoComplete.get(i));
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