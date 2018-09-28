public with sharing class PopulateC {
    public static Map<String, List<Decimal>> returnLineData(String batchName){
        Map<String, List<Decimal>> skillsAndValue = new Map<String, List<Decimal>>();
        ID batchID = [SELECT id FROM training__c WHERE name = :batchName][0].id;
        Batch_Assignment__c[] basses = [SELECT Trainee__r.Id, Trainee__r.Name
                                        FROM Batch_Assignment__c WHERE Training__c = :batchId];
        
        list<Week__c> weeks = [Select id, training__r.Name from week__c where training__r.name = :batchName];
        list<ID> weeksID = new list<ID>();
        for (week__c w: weeks){
             weeksID.add(w.id);
        }
        system.debug(weeks);
        
        
        
        return skillsAndValue ;
    }
}