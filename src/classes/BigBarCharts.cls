public class BigBarCharts {
    
    @AuraEnabled public static RunningAverage[] runningAverageForBatch(String batchName) {
        RunningAverage[] averages = new RunningAverage[]{};
        ID batchID = [SELECT id FROM training__c WHERE name = :batchName][0].id;
        Integer numWeeks = (Integer) [SELECT count(Id)c FROM Week__c WHERE Training__c = :batchId][0].get('c');
        Batch_Assignment__c[] basses = [SELECT Trainee__r.Id, Trainee__r.Name
                                        FROM Batch_Assignment__c WHERE Training__c = :batchId];
        
        for (Batch_Assignment__c bass : basses) {
            Decimal avg = 0;
            for (Assessment__c a : [SELECT Grade__c, Subject__c, Subject__r.Week__c, Subject__r.Weight__c, Subject__r.Week__r.totalWeight__c
                                    FROM Assessment__c WHERE Trainee__c = :bass.Trainee__r.Id AND Week__r.Training__c = :batchId
                                    AND Subject__r.Type__c NOT IN :GradeGridController.specialTypes]) {
                                        if (a.Grade__c == null)
                                            a.Grade__c = 0;
                                        avg += a.Grade__c * a.Subject__r.Weight__c / a.Subject__r.Week__r.totalWeight__c;
                                    }
            averages.add(new RunningAverage(bass.Trainee__r, avg / numWeeks));
        }
        
        return averages;
    }
    
    public class RunningAverage {
        @AuraEnabled public Contact trainee;
        @AuraEnabled public Decimal average;
        
        public RunningAverage(Contact con, Decimal avg) {
            trainee = con;
            average = avg;
        }
    } 
    
    
     @AuraEnabled public static RunningAverage[] runningAverageForBatchWeek(String batchName, String week) {
        Integer newWeek = Integer.valueOf(week.substring(5));
        RunningAverage[] averages = new RunningAverage[]{};
        ID batchID = [SELECT id FROM training__c WHERE name = :batchName][0].id;
        List<week__c> weekList = [SELECT id FROM week__c WHERE training__c = :batchId ORDER BY createddate LIMIT :newWeek];
        List<ID> finalIds = new List<ID>();
         for (week__c w: weekList) {
			finalIds.add(w.id);
         }
        Integer numWeeks = (Integer) [SELECT count(Id)c FROM Week__c WHERE Training__c = :batchId][0].get('c');
        Batch_Assignment__c[] basses = [SELECT Trainee__r.Id, Trainee__r.Name
                                        FROM Batch_Assignment__c WHERE Training__c = :batchId];
        
        for (Batch_Assignment__c bass : basses) {
            Decimal avg = 0;
            for (Assessment__c a : [SELECT Grade__c, Subject__c, Subject__r.Week__c, Subject__r.Weight__c, Subject__r.Week__r.totalWeight__c
                                    FROM Assessment__c WHERE Trainee__c = :bass.Trainee__r.Id AND Week__r.Training__c = :batchId
                                    AND Subject__r.Type__c NOT IN :GradeGridController.specialTypes AND week__c IN :finalIDs]) {
                                        if (a.Grade__c == null)
                                            a.Grade__c = 0;
                                        avg += a.Grade__c * a.Subject__r.Weight__c / a.Subject__r.Week__r.totalWeight__c;
                                    }
            averages.add(new RunningAverage(bass.Trainee__r, avg / numWeeks));
        }
        
        return averages;
    }
    
    @auraenabled
    public static List<Map<String,Decimal>> bigBarAssociate(String batchName, String associateName) {
        RunningAverage[] averages = new RunningAverage[]{};
        ID batchID = [SELECT id FROM training__c WHERE name = :batchName][0].id;
        
        List<Assessment__c> assessList = [Select id, name, grade__c, Subject__r.Weight__c, subject__r.type__C, trainee__r.Name from Assessment__c 
        Where  Week__r.Training__c = :batchId AND Subject__r.Type__c 
        NOT IN :GradeGridController.specialTypes  ];
        
        Map<String,Decimal> batchAverage = new map<string,Decimal>();
        Map<String,Decimal> associateAverage = new map<String,Decimal>();
        Map<String,Map<id,Decimal>> totalWeight = new Map<String, Map<Id,Decimal>>();
       
        for(Assessment__c a : assessList){
        	Decimal weightedScore = a.grade__c * a.Subject__r.Weight__c;
        	
        
        	Map<Id,Decimal> SubjectWeight = totalWeight.get(a.Subject__r.Type__c);
        	
        	if(SubjectWeight == Null){
        	 SubjectWeight = new map<id,Decimal>();
        	 totalWeight.put(a.Subject__r.Type__c,SubjectWeight);
        		
        	}
        	SubjectWeight.put(a.Subject__r.id,a.Subject__r.Weight__c);
        	batchAverage.put(a.Subject__r.Type__c,batchAverage.ContainsKey(a.Subject__r.Type__c)? batchAverage.get(a.Subject__r.Type__c ) + weightedScore : weightedScore);
        	if(a.Trainee__r.Name == associateName){
        		
        	associateAverage.put(a.Subject__r.Type__c,associateAverage.ContainsKey(a.Subject__r.Type__c)? associateAverage.get(a.Subject__r.Type__c ) + weightedScore : weightedScore);
        	
        	}
        }
        Map<String,Decimal> weight = new Map<String,Decimal>();
        for(String typeName :totalWeight.keyset()){
       		Map<Id,Decimal> SubjectWeight = totalWeight.get(typeName);
       		Decimal Sum = 0.0;
       		
        	for(Id subjectId :SubjectWeight.keyset()){
        		sum += SubjectWeight.get(subjectId);
        	}
        	batchAverage.put(typeName,batchAverage.get(typeName)/sum);
        	associateAverage.put(typeName,associateAverage.get(typeName)/sum);
        }
                  
        List<Map<String,Decimal>> Thing = new  List<Map<String,Decimal>>();
        Thing.add(batchAverage);
        Thing.add(associateAverage);
        system.debug(Thing);
        return Thing;
        
    }
    
    @auraenabled
    public static void bigBarAssociateWeek(String associateName, String week) {
        Integer newWeek = Integer.valueOf(week.substring(5));
    }
    
}