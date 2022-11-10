public with sharing class preventFromDuplicateTaskAssignment {

    public static void duplicateTaskAssignmentChecker(List<Task_Assignment__c> assignedtasks) {

        Set<Id> contactIds = new Set<Id>();
        for(Task_Assignment__c pa: assignedtasks){
            contactIds.add(pa.Employee__c);
        }

        // Will fetch existing data of task assigned to employee
        List<Task_Assignment__c > savedpa = [SELECT Id, Name, Employee__c , Training_Task__c 
                                             FROM Task_Assignment__c
                                             WHERE Employee__c IN :contactIds];
        
        List<Id> allocatedtask = new List<Id>();
        //List<Task_Assignment__c > trainingTaskAssignment = new List<Task_Assignment__c >();

        // Map
        Map<Id, List<Id>> mappa = new Map<Id, List<Id>>();
        for(Task_Assignment__c patemp : savedpa){
            if(mappa.containsKey(patemp.Employee__c)){
                List<Id> temp1 = mappa.get(patemp.Employee__c);
                temp1.add(patemp.Training_Task__c);
                mappa.put(patemp.Employee__c, temp1);
            }
            else{
                List<Id> temp = new List<Id>();
                temp.add(patemp.Training_Task__c);
                mappa.put(patemp.Employee__c,temp);
            }
        }
        System.debug(mappa);
        for(Task_Assignment__c at: assignedtasks){
            allocatedtask = mappa.get(at.Employee__c);
            System.debug(allocatedtask);
            if(allocatedtask !=null)
            {
                if(allocatedtask.contains(at.Training_Task__c)){
                     at.addError('Trainee is already assigned with this task');
                }
            }
        }
    }
}