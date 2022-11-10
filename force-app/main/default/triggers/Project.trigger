trigger Project on Project__c (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        TimesheetProjectManagerAssigner.updateTimesheetManagerOnProjectChange(Trigger.new);
    }
}