trigger ProgramAssignment on Program_Assignment__c (after insert, before insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        ProgramRelatedTasksAssigner.assignProgramRelatedTaskstoTrainee(Trigger.new);
    }
    else if(Trigger.isBefore && Trigger.isInsert){
        System.debug('Inside Program Assignment Trigger');
        DuplicateProgramAssignment.duplicateProgramAssignmentFinder(Trigger.new);
    }

}