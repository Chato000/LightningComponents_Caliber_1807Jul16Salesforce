/*
Created By: 1807Jul18 Salesforce Reston VA
last modified: 9/20/18
description: apex controller for TrainingTabs lightning component
*/

public with sharing class TrainingTabsController {
    
    @AuraEnabled
    //get all week records related to assessment record
    public static List<Week__c> getWeeks(id recordId){
        List<Week__c> weeks = [SELECT Id, Name FROM Week__c WHERE Training__r.id = :recordId ORDER BY createdDate Asc];
        return weeks;
    }
    
    @AuraEnabled
    //add new week record to assessment record
    public static Week__c createWeek(id recordId) {
        Week__c newWeek = new Week__C();
        List<Week__c> prevWeeks = getWeeks(recordId);
        newWeek.Name = 'Week ' + String.valueOf(prevWeeks.size() + 1);
        newWeek.Training__c = recordID;
        insert newWeek;
        return newWeek;
    }
    
}