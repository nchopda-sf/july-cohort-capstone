public with sharing class TimesheetRejectionCounter {
    public TimesheetRejectionCounter() {

    }

    public static void updateTimeRejectedOnRejection(List<Time_Sheet__c> updatedTimesheets, Map<Id, Time_Sheet__c> oldTimesheetsMap){
        for(Time_Sheet__c timesheet: updatedTimesheets){
            if(timesheet.Status__c == 'Rejected' && oldTimesheetsMap.get(timesheet.Id).Status__c != 'Rejected')
                {
                if(timesheet.Rejection_Count__c == null){
                    timesheet.Rejection_Count__c = 0;
                }
                timesheet.Rejection_Count__c += 1;
            }
        }

    }
}