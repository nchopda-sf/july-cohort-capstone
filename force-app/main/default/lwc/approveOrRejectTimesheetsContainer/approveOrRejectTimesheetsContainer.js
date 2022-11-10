import { LightningElement, api, wire } from 'lwc';
import getRelatedTimesheets from '@salesforce/apex/TimesheetsController.getRelatedTimesheets';
import { refreshApex } from '@salesforce/apex';
import approveOrRejectTimesheets from '@salesforce/apex/TimesheetsController.approveOrRejectTimesheets';
//import rejectTimesheets from '@salesforce/apex/TimesheetsController.rejectTimesheets';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class ApproveOrRejectTimesheetsContainer extends LightningElement {
   
    @api recordId;
    wiredTimesheets;
    timesheets;


    // This is the base predefined function which will call automatically when component will load/render
    connectedCallback(){
       /* getRelatedTimesheets({ projectId: this.recordId})
        .then(result => {
            this.timesheets = result;
            console.log(result);
        })
        .catch(error => {
            console.warn(error);
        }) */
    }

    @wire(getRelatedTimesheets,{projectId: '$recordId'})
    wiredGetRelatedTimesheets(response){
        this.wiredTimesheets = response;
        if(response.data){
            this.timesheets = response.data;
            console.log(response.data);
        }
        else if(response.error){
            console.log(response.error);
        }
    }

    handleApproveTimesheets(event){
        let timesheetsToApproveOrReject = event.detail.timesheetsToApprove;
        let actiontype = event.detail.actiontype;
        console.log('approve timesheet event handler');
        console.log(timesheetsToApproveOrReject);

        approveOrRejectTimesheets({ timesheetsToApproveOrReject: timesheetsToApproveOrReject, actiontype: actiontype})
        .then(result => {
            console.log('Timesheets approved Successfully !!!');

            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message: 'Timesheets approved Successfully !!',
                variant:'success',
                mode:'pester'

            }));

            refreshApex(this.wiredTimesheets);
            this.template.querySelector('c-approve-or-reject-timesheet-table').toggleModal();
        })
        .catch(error => {
            console.warn(error);
        })
    }

    handleRejectTimesheets(event){
        let timesheetsToApproveOrReject = event.detail.timesheetsToReject;
        let actiontype = event.detail.actiontype;
        console.log('reject timesheet event handler');
        console.log(timesheetsToApproveOrReject);

        approveOrRejectTimesheets({ timesheetsToApproveOrReject: timesheetsToApproveOrReject, actiontype: actiontype})
        .then(result => {
            console.log('Timesheets rejected Successfully !!!');
            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message: 'Timesheets rejected Successfully !!',
                variant:'error',
                mode:'sticky'

            }));
            refreshApex(this.wiredTimesheets);
            this.template.querySelector('c-approve-or-reject-timesheet-table').toggleModal();
        })
        .catch(error => {
            console.warn(error);
        })
    }

    handleRefreshApexEvent(event) {
        if(event.detail.message === 'success') {
            refreshApex(this.wiredTimesheets);
        }
    }
}