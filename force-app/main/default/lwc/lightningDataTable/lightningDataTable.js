import { LightningElement, wire, track, api } from 'lwc';
import getSobjectRecords from '@salesforce/apex/LightningDataTableController.getSobjectRecords'

export default class LightningDataTable extends LightningElement {
    @track mydata;
    @track mycolumns;
    @track error;
    @api sObjectName;
    @api fieldSetName;
    @api recordId = '';
    @api sObjectLookupIDField = '';
    @api additionalWhereClause = '';

    @wire(getSobjectRecords,({
        sObjectName : '$sObjectName',
        fieldSetName : '$fieldSetName',
        recordId : '$recordId',
        sObjectLookupIDField : '$sObjectLookupIDField',
        additionalWhereClause : '$additionalWhereClause',
    }))
    wiredAccounts({error, data}){
        if(data){
            this.mycolumns = data.listColumns;
            this.mydata = data.dataTableData;
            this.error = undefined;
            }else if(error){
            this.error = error;
            this.mydata = undefined;    
            this.mycolumns = undefined;
            }
    }
}