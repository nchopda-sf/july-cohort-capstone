import { LightningElement,api,wire, track } from 'lwc';
import getTrainingTasks from '@salesforce/apex/AssignTrainingTasksController.getTrainingTasks';
import insertTrainingTasks from '@salesforce/apex/AssignTrainingTasksController.insertTrainingTasks';
import NAME_FIELD from '@salesforce/schema/Training_Task__c.Name';
import TASK_TYPE_FIELD from '@salesforce/schema/Training_Task__c.Task_type__c';
import TASK_LENGTH_FIELD from '@salesforce/schema/Training_Task__c.Task_Length__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class CreateProgramTasks extends LightningElement{
    @api recordId;
    @api trainingtasks;
    wiredTrainingTasks;
    @api searchKey = '';

    name = NAME_FIELD;
    tasktype = TASK_TYPE_FIELD;
    tasklength = TASK_LENGTH_FIELD;

    
    selectTrainingTasks = true;
    newTrainingTaskModalshown = false;

    buttonToNext = true;

    selectedTainingTasks = [];
    @api searchSelectedRows = [];

   handelSearchKey(event){
            this.searchKey = event.target.value;
            console.log('searchKey : '+ this.searchKey);

            // make list on the basis of search key, and display on screen
    }

    @wire(getTrainingTasks,{programId: '$recordId', textkey : '$searchKey'})
    wiredGetTrainingTasks(response){
        this.wiredTrainingTasks = response;
        
        if(response.data){
            this.trainingtasks = response.data;
            console.log('Training Task : '+ JSON.stringify(this.trainingtasks));
        }
        else if(response.error){
            this.trainingtasks = null;
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
        this.searchSelectedRows.push(selectedRows);
        console.log('Selected Training Task : '+ JSON.stringify(this.searchSelectedRows));

        

        if(selectedRows.length>0){
            this.buttonToNext = false;
        }
        else{
            this.buttonToNext = true;
        }

        // Only when you want to see the data on console, at that time you need to simplify the JSON result
        // When you want to work with the data, you don't need to do anything 
        //console.log(JSON.parse(JSON.stringify(selectedRows)));
        this.selectedTainingTasks = selectedRows;       

        // append result to varible 
    }

    saveSelectedTrainingTasks(event){

        let daystoComplete = [];
        var aa = [...this.template.querySelectorAll('.days-to-complete')];
        
        aa.forEach( input => {
            daystoComplete.push(input.value);
         });

        insertTrainingTasks({ selectedTainingTasks: this.selectedTainingTasks, daystoComplete: daystoComplete, programId:this.recordId})
        .then(result => {
            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message: 'Training Tasks Successfully associated to program !',
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

    handleCreateNewTrainingTask(event){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleSucessfulInsert(event){
        
        this.dispatchEvent(new ShowToastEvent({
            title:'Success',
            message: "Training task hase been successfully created!" ,
            variant:'success',
            mode:'pester'
        }));
        
        this.newTrainingTaskModal();
        refreshApex(this.wiredTrainingTasks);
    }

    nextButtonHandler(){
        this.toggleSelectedTrainingTasks();
    }

    backButtonHandler(){
        this.toggleSelectedTrainingTasks();
        this.selectedTainingTasks = null;
        this.buttonToNext = true;
    }

    toggleSelectedTrainingTasks(){
        this.selectTrainingTasks = !this.selectTrainingTasks;
    }

    closeQuickAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    newTrainingTaskModal(){
        this.newTrainingTaskModalshown = !this.newTrainingTaskModalshown;
    }
}