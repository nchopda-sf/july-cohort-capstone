trigger Timesheet on Time_Sheet__c (before update, before insert) {
    if(Trigger.isBefore && Trigger.isUpdate){
        TimesheetRejectionCounter.updateTimeRejectedOnRejection(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isBefore && Trigger.isInsert){
        TimesheetProjectManagerAssigner.assignTimesheetManagerFromProject(Trigger.new);
    }
}