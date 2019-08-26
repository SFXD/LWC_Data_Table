public with sharing class LightningDataTableController {
    /*
    Created by Phill Drum
    Purpose:  Create a lightning-datatable based on configuration inputs to create lists, related lists, filtered lists, and filtered related lists.
    Based off of http://sfdcmonkey.com/2018/01/05/lightning-datatable-base-component/
    */
    @AuraEnabled(cacheable=true)
    public static DataTableResponse getSobjectRecords(String sObjectName, String fieldSetName, String sObjectLookupIDField, String additionalWhereClause, String recordId){

        //Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        //List to hold table headers
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        
        //Fields to be queried from fieldset
        List<String> lstFieldsToQuery = new List<String>();
        
        //Final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
            //This way we can set the type of a column
            //We do not get the exact type from schema object which matches to lightning-datatable component structure
            if(dataType == 'datetime'){
                dataType = 'date';
            }
            //Create a wrapper instance and store label, fieldname and type.
            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
                                                                String.valueOf(eachFieldSetMember.getFieldPath()), 
                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase() );
			lstDataColumns.add(datacolumns);
            lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
        }
        
        //SOQL Queries for different lists:  lists, related lists, filtered lists, and filtered related lists
        String query = '';
        if(!lstDataColumns.isEmpty() && String.isEmpty(recordId) && String.isEmpty(additionalWhereClause) && String.isEmpty(sObjectLookupIDField)){
            //List
            query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +
                    ' FROM ' + sObjectName;
            System.debug(query);
        }else if (! lstDataColumns.isEmpty() && String.isEmpty(additionalWhereClause)){
            //Related List
            query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +
                    ' FROM ' + sObjectName +
                    ' WHERE ' + sObjectLookupIDField +  ' = \'' + recordId + '\'';
        }
        else if (! lstDataColumns.isEmpty() && String.isEmpty(recordId)){
            //Filtered List    
            query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +
                    ' FROM ' + sObjectName +
                    ' WHERE ' + additionalWhereClause;
        }
        else{
            //Filtered Related List
            query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +
                ' FROM ' + sObjectName +
                ' WHERE ' + sObjectLookupIDField +  '= \'' + recordId + '\''+
                ' AND '+ additionalWhereClause;
        }
        response.dataTableData = Database.query(query);
        response.listColumns = lstDataColumns;
        return response;
    }
    
    //Wrapper class to hold Columns with headers
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        //Create and set variables required by lightning-datatable (label, fieldname, and type)
        public DataTableColumns(String label, String fieldName, String type){
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;            
        }
    }
    
    //Wrapper calss to hold response
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> listColumns {get;set;}
        @AuraEnabled
        public List<sObject> dataTableData {get;set;}                
        
        public DataTableResponse(){
            listColumns = new List<DataTableColumns>();
            dataTableData = new List<sObject>();
        }
    }
}