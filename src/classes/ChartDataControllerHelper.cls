public class ChartDataControllerHelper {
	@AuraEnabled public static RunningAverage[] runningAverageForBatch(Id batchId) {
		RunningAverage[] averages = new RunningAverage[]{};
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
}