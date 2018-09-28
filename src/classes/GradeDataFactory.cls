public class GradeDataFactory {

   /* public static Batch_Assignment__c createBatchAssign(Integer x){
        Contact trainee = new Contact();
        Training_Track__c trainingTrack = new Training_Track__c();
        Training__c training = new Training__c();
        insert training;
        trainee.FirstName = 'Sylvester';
        trainee.LastName = 'Stalone';
        insert trainee;
 	 Batch_Assignment__c ba = new Batch_Assignment__c();
            ba.Start_Date__c = Date.newInstance(2018, 09, 17);
      		ba.Trainee__c = trainee.Id;
        	ba.Training__c = training.Id;
         insert ba;
		 return ba;        
    }*/
    public static List<Training__c> createTrainings(Integer x ){
        List<Training__c> tList = new List<Training__c>();
        List<Week__c> wList = new List<Week__c>();
        for(Integer i = 0; i < x; i++){
            Training__c training = new Training__c();
            training.Start_Date__c = Date.newInstance(2018, 9, 19);
            tList.add(training);
        }
        insert tList;

        for(Training__c train : tList){
             Week__c week1 = new Week__c();
             week1.Name = 'Week 1';
             week1.Notes__c = 'Notes... Notes.... Notes...';
         	 week1.Training__c = train.id;
             wList.add(week1);
        }
        insert wList;
        return tList;
    }
    
    public static List<Week__c> createWeeks(Integer x){
        List<Training__c> tList = new List<Training__c>();
         Training__c training = new Training__c();
         training.Start_Date__c = Date.newInstance(2018, 9, 19);
        insert training;
        List<Week__c> wList = new List<Week__c>();
        for(Integer i = 0; i < x; i++){
            Week__c week1 = new Week__c();
             week1.Name = 'Week 1';
             week1.Notes__c = 'Notes... Notes.... Notes...';
         	 week1.Training__c = training.id;
            wList.add(week1);
        }
        insert wList;
        return wList;
    }
    public static List<Contact> createContacts(Integer x){
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < x; i++){
        Contact trainee = new Contact();
        trainee.FirstName = 'Sylvester'+ i;
        trainee.LastName = 'Stalone' + i;
        conList.add(trainee);
        }
        insert conList;
        return conList;
    }
    public static List<Assessment__c> createAssessments(Integer x){
        List<Assessment__c> aList = new List<Assessment__c>();
        for(Integer i = 0; i < x; i++){
          Assessment__c assessment = new Assessment__c();
          Subject__c sub = createSubjects(1)[0];
            assessment.Subject__c = sub.id;
            assessment.Week__c = sub.Week__c;
            assessment.Trainee__c = createContacts(1)[0].id;
            aList.add(assessment);
        }
        insert aList;
        return aList;
    }
     public static Subject__c[] createSubjects(Integer x){
        Contact trainee = new Contact();
        Training_Track__c trainingTrack = new Training_Track__c();
        Training__c training = new Training__c();
        training.Start_Date__c = Date.newInstance(2018, 9, 19);
        insert training;
        trainee.FirstName = 'Sylvester';
        trainee.LastName = 'Stalone';
        insert trainee;
        Week__c week1 = new Week__c();
             week1.Name = 'Week 1';
             week1.Notes__c = 'Notes... Notes.... Notes...';
         	 week1.Training__c = training.id;
             insert week1;
         List<Subject__c> subList = new List<Subject__c>();
         for(Integer i = 0; i < x; i++){
             Subject__c sub = new Subject__c();
            sub.Type__c = 'Project';
            sub.Category__c = 'SQL';
            sub.Weight__c = 0.8;
            sub.Week__c = week1.id;
            subList.add(sub);
         }
        
        insert subList;
         Id weekId = week1.id;
         system.debug( 'WeekID = '+ weekId + ' Found: ' + [SELECT Id FROM Subject__c WHERE Week__c = :weekId]);
         system.debug([SELECT Id FROM Week__c]);
         system.debug([SELECT Id FROM Subject__c]);
         return subList;
    }

}