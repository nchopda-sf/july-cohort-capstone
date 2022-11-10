import { LightningElement,api,wire } from 'lwc';
import getTrainingTasks from '@salesforce/apex/AssignTrainingTasksController.getTrainingTasks';
import insertTrainingTasks from '@salesforce/apex/AssignTrainingTasksController.insertTrainingTasks';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class Test extends LightningElement{
    @api recordId;
    @api trainingtasks;
    wiredTrainingTasks;
    

    selectTrainingTasks = true;

    selectedTainingTasks = [];

    @wire(getTrainingTasks,{programId: '$recordId'})
    wiredGetTrainingTasks(response){
        this.wiredTrainingTasks = response;
        
        if(response.data){
            this.trainingtasks = response.data;
            console.log(response.data);
        }
        else if(response.error){
            console.log(response.error);
        }
    }
  
    columns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Training Type', fieldName: 'Task_type__c'},
        {label: 'Training Length', fieldName: 'Task_Length__c'}
    ];

    columns2 = [
        {label: 'Name', fieldName: 'Name'},
        /*{label: 'Days to Complete', fieldName: 'Days_to_Complete', type: 'number', editable: true}*/
    ];

    handleSelectedRows(event){
        let selectedRows = event.detail.selectedRows;

        // Only when you want to see the data on console, at that time you need to simplify the JSON result
        // When you want to work with the data, you don't need to do anything 
        console.log(JSON.parse(JSON.stringify(selectedRows)));

        this.selectedTainingTasks = selectedRows;
    }

    saveSelectedTrainingTasks(event){

        let daystoComplete = [];
        console.log('Inside saveSelectedTrainingTasks');
        debugger;
        var daystocompleteresultlist = [...this.template.querySelectorAll('.days-to-complete')];
        
        daystocompleteresultlist.forEach( input => {
            console.log(input.value);
            daystoComplete.push(input.value);
         });


        console.log('daystoCompelete List : '+daystoComplete);

        //const arrayofinput = [...this.template.querySelectorAll('.days-to-complete')];
        //console.log('Days to complete array : '+arrayofinput);


        insertTrainingTasks({ selectedTainingTasks: this.selectedTainingTasks, daystoComplete: daystoComplete, programId:this.recordId})
        .then(result => {
            console.log('Training Tasks Successfully associated to program !');

            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message: 'Training Tasks Successfully associated to program !',
                variant:'success',
                mode:'pester'

            }));

            refreshApex(this.wiredTrainingTasks);
            //this.toggleSelectedTrainingTasks();
            this.closeQuickAction();
        })
        .catch(error => {
            console.warn(error);
        })

    }

    nextButtonHandler(){
        this.toggleSelectedTrainingTasks();
    }

    backButtonHandler(){
        this.selectedTainingTasks = null;
        this.toggleSelectedTrainingTasks();
    }

    toggleSelectedTrainingTasks(){
        this.selectTrainingTasks = !this.selectTrainingTasks;
    }

    closeQuickAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}