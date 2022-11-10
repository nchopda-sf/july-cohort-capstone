public with sharing class ProgramRelatedTasksAssigner {
 

    public static void assignProgramRelatedTaskstoTrainee(List<Program_Assignment__c> insertedProgramAssignments){

        Set<Id> newlyAssignedProjects = new Set<Id>();
        List<Task_Assignment__c > relatedTrainingTaskstobeinsert = new List<Task_Assignment__c >();

        for(Program_Assignment__c programassignment : insertedProgramAssignments){
            newlyAssignedProjects.add(programassignment.Program__c);
        }

         // To create Map - How many tasks are assigned to one program
        List<Program_Task__c > programtasks = [SELECT Id, Name, Program__c, Training_Task__c, Days_to_Complete__c 
                                                FROM Program_Task__c
                                                WHERE Program__c IN :newlyAssignedProjects] ;

        for(Program_Assignment__c pa : insertedProgramAssignments){
            for(Program_Task__c pt : programtasks){
                if(pa.Program__c == pt.Program__c){
                    Task_Assignment__c ta = new Task_Assignment__c();
                    ta.Program__c = pa.Program__c ;
                    ta.Employee__c = pa.Employee__c;
                    ta.Training_Task__c = pt.Training_Task__c;
                    ta.Start_Date__c = pa.Start_Date__c;
                    ta.Due_Date__c = pa.Start_Date__c.addDays(Integer.valueOf(pt.Days_to_Complete__c));
                    relatedTrainingTaskstobeinsert.add(ta);
                }
            }
        }

        // Inserting related training tasks to the program
        try{
            insert relatedTrainingTaskstobeinsert;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}