import { LightningElement, api } from 'lwc';
import STATUS_FIELD from '@salesforce/schema/Time_Sheet__c.Status__c';
import PROJECT_FIELD from '@salesforce/schema/Time_Sheet__c.Project__c';
import TIMESHEET_INSERTION_SUCCESS from '@salesforce/label/c.Timesheet_Insertion_Success'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class ApproveOrRejectTimesheetTable extends LightningElement {
    @api timesheets;
    @api projectid;

    statusField = STATUS_FIELD;
    projectField = PROJECT_FIELD;

    modelShown = false;
    buttonShown = true;
    selectedTimesheets = [];
    mode;

    isInsertNewTimesheetShown = false;

    columns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Status', fieldName: 'Status__c'},
        {label: 'Times Rejected', fieldName: 'Rejection_Count__c'}
    ];

    // Use of getter method to show approve/reject buttons on the basis of number of timesheet selection
    // If no timesheet selected -> It should not show approve/reject buttons
    // If atleast 1 timesheet is selected -> Show both approve/reject buttons 

    /* we can also write the same condition in short manner : 
    return this.selectedTimesheets.length === 0;   */

    
    get noTimesheetsSelected(){
        if(this.selectedTimesheets.length>0){
            return false;
        }
        else{
            return true;
        }
    }

    handleSelectedRows(event){
        let selectedRows = event.detail.selectedRows;

        // Only when you want to see the data on console, at that time you need to simplify the JSON result
        // When you want to work with the data, you don't need to do anything 
        console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedTimesheets = selectedRows;

       
    }

    approveTimesheets(){
        // Approve selected rows of Timesheets

        // We are creating event bundle and passing it to the parent component (Container) 
        // We are also binding the selected row value so that parent component can interact with apex
        // approvetimesheets - All should be in lower case and in parent component HTML file, we will use "onapprovetimesheets"
        const evt = new CustomEvent('approvetimesheets', {
            detail: {
                timesheetsToApprove: this.selectedTimesheets,
                actiontype : 'approve'
            }
        });

        this.dispatchEvent(evt);

        console.log('approve timesheets event fired');
        //this.modelShown = !this.modelShown
        
    }

    rejectTimesheets(){
        // Reject selected rows of Timesheets
        const evt = new CustomEvent('rejecttimesheets', {
            detail: {
                timesheetsToReject: this.selectedTimesheets,
                actiontype : 'reject'
            }
        });

        this.dispatchEvent(evt);

        console.log('reject timesheets event fired');
        //this.modelShown = !this.modelShown
    }

    @api toggleModal(){
        this.modelShown = !this.modelShown;
    }

    toggleModalBody(){
        this.isInsertNewTimesheetShown = !this.isInsertNewTimesheetShown
    }

    // We have used Custom Label to display the success message
    handleSucessfulInsert(event){
        console.log('Inside Add handler');
        this.dispatchEvent(new ShowToastEvent({
            title:'Success',
            message: TIMESHEET_INSERTION_SUCCESS ,
            messageData: [event.detail.id],
            variant:'success',
            mode:'pester'
        }));

        let eventPaytload = {
            detail:{
                message : "success"
            }
        } 

        this.dispatchEvent(new CustomEvent('refreshapexevent',eventPaytload))

        this.toggleModalBody();
    }

    handleCreateNewTimesheet(){
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}