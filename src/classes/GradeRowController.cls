public with sharing class GradeRowController {
	@auraenabled public static Id[] getAssessments(Id traineeId, Id weekId, Subject__c[] subjects) {
		if (subjects.size() == 0)
			return new Id[]{};

		// select any existing Assessment__c record for each Subject__c record
		final Map<Id, Assessment__c> bySub = new Map<Id, Assessment__c>();
		for (Assessment__c a : [SELECT Id, Subject__c from Assessment__c where Subject__c in :subjects AND Trainee__c = :traineeId])
			bySub.put(a.Subject__c, a);

		// create new Assessment__c records where any were missing
        final Map<String, Schema.RecordTypeInfo> rti = Schema.SObjectType.Assessment__c.getRecordTypeInfosByDeveloperName();
		Assessment__c[] autoVivified = new Assessment__c[]{};
		for (Subject__c sub : subjects)
			if (!bySub.containsKey(sub.Id)) {
				Assessment__c na = new Assessment__c(Subject__c=sub.Id, Week__c=weekId,
					Trainee__c=traineeId, RecordTypeId=rti.get(sub.Type__c).getRecordTypeId());
				autoVivified.add(na);
				bySub.put(sub.Id, na);
			}

		insert autoVivified;

		Id[] assessments = new Id[]{};
		for (Subject__c sub : subjects)
			assessments.add(bySub.get(sub.Id).Id);
		return assessments;
	}
}