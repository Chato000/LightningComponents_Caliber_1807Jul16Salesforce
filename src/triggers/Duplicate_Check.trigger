trigger Duplicate_Check on Batch_Assignment__c (before insert) {
	
	list<Batch_Assignment__c> assignments = new list<Batch_Assignment__c>();
	assignments = [SELECT id, name, training__c, trainee__c 
					FROM Batch_Assignment__c];
	Batch_Assignment__c[] new_assignments = Trigger.new;
	
	//compare each new/updated assignment with all assignments, check for duplicate trainees
	//in trainings and rejects if found
	for (Batch_Assignment__c new_assign : new_assignments) {
		for (Batch_Assignment__c assign : assignments) {
			boolean duplicate = false;
			if (assign.trainee__c == new_assign.trainee__c && 
				  	assign.training__c == new_assign.training__c) {
				duplicate = true;
			}
			if (duplicate) {
				new_assign.addError('Trainee already assigned to batch.');
			}
		}
	}
}