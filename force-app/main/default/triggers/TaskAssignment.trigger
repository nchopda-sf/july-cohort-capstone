trigger TaskAssignment on Task_Assignment__c (before insert) {

    /*
    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('Inside TaskAssignment Trigger');
        preventFromDuplicateTaskAssignment.duplicateTaskAssignmentChecker(Trigger.new);
    }*/
}