public with sharing class ProjectDuplicateChecker {

    @InvocableMethod(description='Return Duplicate Projects' category='Project')
    public static List<Project__c> checkForDuplicateProjects(List<Id> projectId){
        List<Project__c> currentProjects = [SELECT Name
                                            FROM Project__c
                                            WHERE Id IN :projectId];

        if(currentProjects.size()>0){
            return [SELECT Id,Name
                    FROM Project__c
                    WHERE Name=:currentProjects[0].Name];
        }

        return null;

    }
}