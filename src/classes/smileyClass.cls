public class smileyClass {
	@AuraEnabled
    public static List<week__c> returnSmileyData(String batchName){
        List<week__c> weeks = 	[Select id, name,   
                                	(Select trainee__c, Integer_Smilie__c from Assessments__r where Assessment_Type__c = 'QC' ) 
                                from week__c 
                                where training__r.name = :batchName];
        
        //the follwoing list will have list of weeks for a given batch
        list<String> weeksList = new List<String>();
        for(week__c week: weeks){
            weeksList.add(week.Name);
        }
        
        return weeks;
    }
}

/*
public with sharing class ContactController {
    @AuraEnabled
    public static List<Contact> getContacts() {
        List<Contact> contacts =
                [SELECT Id, Name, Phone, Email FROM Contact];
        //Add isAccessible() check
        return contacts;
    }
}*/