public with sharing class TimesheetProjectManagerAssigner {

    public static void assignTimesheetManagerFromProject(List<Time_Sheet__c> insertedTimesheets){
        Set<Id> projectIds = new Set<Id>();

        for(Time_Sheet__c timesheet: insertedTimesheets){
            projectIds.add(timesheet.Project__c);
        }

     
        Map<Id, Project__c> assignedProjects= new Map<Id, Project__c> ([SELECT Project_Manager__c FROM Project__c WHERE Id IN :projectIds]);

        for(Time_Sheet__c timesheet: insertedTimesheets){
            if(assignedProjects.containsKey(timesheet.Project__c)){
                timesheet.Project_Manager__c = assignedProjects.get(timesheet.Project__c).Project_Manager__c;
            } 
        }

    }

    public static void updateTimesheetManagerOnProjectChange(List<Project__c> updatedProjects){
        Set<Id> projectIds = new Set<Id>();
        // Created Map
        Map<Id,Id> projectMap = new Map<Id,Id>();
        
        for(Project__c project: updatedProjects){
            projectIds.add(project.Id); 
            // Manipulating Map
            projectMap.put(project.Id, project.Project_Manager__c);
    
        }

        List<Time_Sheet__c> childTimesheets = [SELECT Project_Manager__c, Project__c, Project__r.Project_Manager__c
                                               FROM Time_Sheet__c 
                                               WHERE Project__c IN :projectIds];
       

        for(Time_Sheet__c timesheet: childTimesheets){
            /*for(Project__c project: updatedProjects){
                if(timesheet.Project__c == project.Id){

                    timesheet.Project_Manager__c = project.Project_Manager__c;
                }

            }*/

            // Use of Map collection can reduce nested for loop
            if(projectMap.containsKey(timesheet.Project__c)){
                timesheet.Project_Manager__c = projectMap.get(timesheet.Project__c);
            }
        }

        update childTimesheets;

    }
}