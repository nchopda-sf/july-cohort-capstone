import { LightningElement,api,wire } from 'lwc';
import getTrainingTasks from '@salesforce/apex/RemoveTrainingTasksController.getTrainingTasks';
import removeTrainingTasks from '@salesforce/apex/RemoveTrainingTasksController.removeTrainingTasks';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class RemoveProgramTasks extends LightningElement{
    @api recordId;
    @api trainingtasks;
    wiredTrainingTasks;

    selectedTainingTasks = [];

    buttonToRemove = true;

    @wire(getTrainingTasks,{programId: '$recordId'})
    wiredGetTrainingTasks(response){
        this.wiredTrainingTasks = response;
        
        if(response.data){
            this.trainingtasks = response.data;
        }
        else if(response.error){
            console.log(response.error);
        }
    }
  
    trainingtasksfields = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Training Type', fieldName: 'Task_type__c'},
        {label: 'Training Length', fieldName: 'Task_Length__c'}
    ];

    handleSelectedRows(event){
        let selectedRows = event.detail.selectedRows;

        if(selectedRows.length>0){
            this.buttonToRemove = false;
        }
        else{
            this.buttonToRemove = true;
        }

        // Only when you want to see the data on console, at that time you need to simplify the JSON result
        // When you want to work with the data, you don't need to do anything 
        //console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedTainingTasks = selectedRows;
    }

    removeSelectedTrainingTasks(event){

        removeTrainingTasks({ selectedTainingTasks: this.selectedTainingTasks, programId:this.recordId})
        .then(result => {
            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message: 'Training Tasks Successfully Removed !',
                variant:'success',
                mode:'pester'

            }));

            refreshApex(this.wiredTrainingTasks);
            eval("$A.get('event.force:refreshView').fire();");
            this.closeQuickAction();

        })
        .catch(error => {
            console.warn(error);
        })

    }

    closeQuickAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
        this.buttonToRemove = true;
    }
}