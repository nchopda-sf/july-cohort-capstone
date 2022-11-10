public with sharing class DuplicateProgramAssignment {
   
    public static void duplicateProgramAssignmentFinder(List<Program_Assignment__c> newListOfProgramAssignment) {

        // Identifying the unique trainee/contact asspciated with new program assignments to filter the query
        Set<Id> contactIds = new Set<Id>();
        for(Program_Assignment__c pa: newListOfProgramAssignment){
            contactIds.add(pa.Employee__c);
        }

        // Fetch Existing Program Assignment List to check whether the program is already assigned or not
        List<Program_Assignment__c> existingProgramAssignmentsforContact = [SELECT Id, Name, Employee__c , Program__c  
                                                                            FROM Program_Assignment__c
                                                                            WHERE Employee__c IN :contactIds];

        

        // Map - To store already assigned programs to individual trainee/contact
        Map<Id, List<Id>> existingContactProgramMap = new Map<Id, List<Id>>();

        for(Program_Assignment__c pa : existingProgramAssignmentsforContact){
            if(existingContactProgramMap.containsKey(pa.Employee__c)){
                List<Id> temp1 = existingContactProgramMap.get(pa.Employee__c);
                temp1.add(pa.Program__c);
                existingContactProgramMap.put(pa.Employee__c, temp1);
            }
            else{
                List<Id> temp = new List<Id>();
                temp.add(pa.Program__c);
                existingContactProgramMap.put(pa.Employee__c,temp);
            }
        }

    
        // To store the result of already assigned programs from the Map
        List<Id> assignedPrograms = new List<Id>();

        // Iterating through new program assignments records, and retriving already assigned programs from Map using the trainee/contact id
        for(Program_Assignment__c pa: newListOfProgramAssignment){
            assignedPrograms =  existingContactProgramMap.get(pa.Employee__c);

            if(assignedPrograms != null){
                if(assignedPrograms.contains(pa.Program__c)){
                    
                    // Showing Error on Page on Duplicate Program Assignmnet
                    pa.addError('Trainee is already assigned with this program');
                }
            }
        }
    }
}