public with sharing class filteringData {

    @AuraEnabled 
    public Static List<List<String>> returnInitData(){
        
        List<List<String>> initData = new List<List<String>>();
        //Get all available years
        Set<String> yrSet = new Set<String>(); //set will make sure only unique values are taken
        for (Training__c t: [select name, start_Date__c, end_Date__c from training__c ]){
            yrSet.add(String.valueOf(t.Start_Date__c.year())); 
        }
        list<String> yrList = new list<String>();
		yrList.addAll(yrSet); //set returns all unique years to the yrList
        
        initData.add(yrList);

        //Create stringlist for quarters
        List<String> q = new List<String> {'Q1', 'Q2', 'Q3', 'Q4'};
        initData.add(q);
        
        return initData;
    }
    
    @AuraEnabled
    public static List<string> returnBatches(Integer yr, Integer quarter){ //return all batch name which either starts or ends withing the given year and quarter. 
        list<String> batches = new list<String>();
        for (Training__c t: [select name, start_Date__c, end_Date__c from training__c ]){
            //Integer givenQuarter = Integer.valueOf(quarter.charAt(1));
            Integer batchQuarter = math.round((t.Start_Date__c.month()+1)/3.0); //converts date to quarter: math.round((month+1)/3.0)
            system.debug('batchQ & quarter param: ' + ' & ' + batchQuarter + ' & ' + quarter);

            if (t.Start_Date__c.year() == yr && quarter == batchQuarter)	
            	batches.add(t.Name);
        }
        return batches;
    }
    
    @AuraEnabled
    public static list<String> returnAssociatesWithBatchName(String batchName){
        List<batch_assignment__c> batchA = [select trainee__c from batch_assignment__c where training__c IN (select id from training__c where name= :batchName)];
        list<ID> batchAID = new list<ID>();
        List<String> trainees = new List<String>();
        for (batch_assignment__c b: batchA){
            batchAID.add(b.trainee__c);
        }
        for(Contact c:[select id, name from Contact where id IN: batchAID]){
			trainees.add(c.name);            
        }
        return trainees;
	}
    
    @auraenabled
    public static List<String> returnWeeksWithBatchName(String batchName) {
    	
    	List<String> weeks = new List<String>();
        List<ID> trainingID = new List<ID>();
        
        for(training__c t: [SELECT id FROM training__c WHERE name = :batchName]) {
            trainingID.add(t.id);
        }
        
        for (week__c w: [SELECT name FROM week__c WHERE training__c IN :trainingID]) {
            weeks.add(w.name);
        }
        return weeks;
    }
    
    
    // --------- big bar chart methods -----------
   
    
    
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
        system.debug(averages);
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
    
    
    
    /*
    			FOR QC TABLE
    			
	*/
	
	//We are currently assuming all select fields are the name of object
	
	//This returns a table with integer smilies
	//to convert integer smilies into url do the following on javascript
	
	/*
	getUrl : function(rating) {
		return $A.get('$Resource.smiles') + '/smiles/' + rating + '.svg';
	}
	*/
	
	//Wrapper class
	
	public class QCTable{
		@auraenabled public List<String> tableHeaders; //the header names
		@auraenabled public List<String> traineeName; //name of trainees
		@auraenabled public Map<String, List<Decimal>> traineeData; //maps trainees to trainee Data
		
		public QCTable(){
			tableHeaders = new List<String>();
			traineeName = new List<String>();
			traineeData = new Map<String, List<Decimal>>();
		}
		
	}
	
	@AuraEnabled
    public static QCTable getQCTableData(string batchSelect){
    	//SQL for weeks and QC Assessments for 
    	List<Week__c> weeks = [Select name,  
        								(Select name, Integer_Smilie__c, trainee__r.name from Assessments__r where Assessment_Type__c = 'QC' ) 
                                from week__c 
                                where training__r.name = :batchSelect];
                            
       //get all the trainees in the batch.
       List<Batch_Assignment__c> BatchAssList = [select trainee__r.name From Batch_Assignment__c where Training__r.name = :batchSelect];
       
       //create a row by column list to display for table values
       QCTable tableR = new QCTable();
       
       //calculate total weeks and trainees
       integer tTrainee = BatchAssList.size();
       integer tWeek = weeks.size();
       
       //first row -> contain headers
       tableR.tableHeaders.add('Trainee');
       for(integer i = 1; i<=tWeek; i++){
       	tableR.tableHeaders.add('Week ' + i);
       }
       
       //create table with 0 smilies
       
       for(Batch_Assignment__c trainee: batchAssList){
       	tableR.TraineeName.add(trainee.trainee__r.name);
       	
       	//search assessment in week and add corresponding results
       	List<Decimal> SmilieList = new List<Decimal>();
       	for(integer i =0; i<tWeek; i++){
       		SmilieList.add(0);
       	}
       	
       	tableR.TraineeData.put(trainee.trainee__r.name, SmilieList);

       }
       
       //loop through assessment and update smilies
       for(Week__c wek : weeks){
       	//get current week and loop through assessments
       	Integer currentWeek = integer.valueOf(wek.name.substring(5));
       	
       	for(Assessment__c asse : wek.Assessments__r){
       		List<Decimal> smilieList = tableR.traineeData.get(asse.trainee__r.name);
       		if(smilieList != null && asse.Integer_Smilie__c != null){
	       		smilieList[currentWeek-1] = asse.Integer_Smilie__c;
	       		tableR.traineeData.put(asse.trainee__r.name, smilieList);
       		}
       	} 
       	
       }
       
       //Must add in the final value which is the average if there are trainers and weeks
       if(tTrainee > 0 && tWeek > 0){
	       List<Decimal> avgList = new List<Decimal>();
	       for(integer i =0; i<tWeek; i++){
	       	avgList.add(0.0);
	       }
	       
	      for(String keyname: tableR.traineeData.keySet()) {
	       	List<Decimal> smilieList = tableR.traineeData.get(keyname);
	       	if(smilieList != null){
		       	for(integer i = 0; i<tWeek; i++){
		       		avgList[i] = avgList[i] + smilieList[i];
		       	}
	       	}
	      }
	       
	      for(integer i =0; i<tWeek; i++){
	       avgList[i] = avgList[i] / tWeek;
	       avgList[i] = avgList[i] > 2.5 ? 3 : avgList[i] >= 2 ? 2 : 1;
	      }
	       
	      tableR.traineeData.put('Overall', avgList);
       }
       
       //should contain all updated fields
	   system.debug(tableR);       
       return tableR;
       
    }
    
    //----------------- Radar Chart Methods -----------------//
 
    
     /*The following method returns a map in the following format- map[key:JAVA, val: ({sumOfTotalWightForAllJavaSubject},{sumOfTotalWeightedGrade})]
	 * each key(represent a skill) with a list of double {total Weights For for Skill A, total Weighted Grade Received for skill A}
     * The ratio was normalized (while keeping the ratio proportinate) to show 100:x
     * This method will not ignore: 1. any Subject__c with category == null, Weight == null, 2. Assignment__c with grade == null
     */
    @AuraEnabled
    public static Map<String, List<Decimal>> returnRadarData(String batchName){
        Map<String, List<Decimal>> skillsAndValue = new Map<String, List<Decimal>>(); //e.g map[key:JAVA, value:List({sumOfTotalWightForAllJavaSubject},{sumOfTotalWeightedGrade})]
        
        //starting query
        //weeks
        list<Week__c> weeks = [Select id, training__r.Name from week__c where training__r.name = :batchName];
        list<ID> weeksID = new list<ID>();
        for (week__c w: weeks){
             weeksID.add(w.id);
        }
        system.debug(weeks);
        
        //subject
        list<subject__c> subjects = [select Category__c, weight__c, week__c from subject__c where Category__c != null and weight__c !=null and Week__c IN: weeksID];
        system.debug(subjects);
        
        //lets gather all skillsets into the map as keys. e.g XML, AJAX, JQuery 
        Set<String> skills = new Set<String>();
        for (subject__c s: subjects){
            skills.add(s.Category__c);
        }
        for(String s: skills){
            skillsAndValue.put(s, new List<Double>{0, 0});
        }
        
        
       //assessment
       list<assessment__c> assessments = [select id, grade__c, week__c, subject__c from assessment__c where week__c IN: weeksID and grade__c != null];
       system.debug(assessments);
       
       //In this part we'll 
       list<list<Decimal>> totalWeightAndWightedGrade = new list<list<Decimal>>(); 
       //list<Decimal> temp = new list<Decimal>();
       List<Decimal> existingSkillValue = new List<Decimal>();
       Decimal weightedGrade = 0;
       
       //get sum of all skills weights and weightedAssigmentGrade
       for(week__c w: weeks){
            for(subject__c s: subjects){
                if(s.week__c == w.Id){
                    for (assessment__c a: assessments){
                        if(a.Subject__c == s.Id){
                            existingSkillValue = skillsAndValue.get(s.Category__c);
                            existingSkillValue[0] = existingSkillValue[0]+s.Weight__c;
                            existingSkillValue[1] = existingSkillValue[1]+(s.Weight__c/100) * a.Grade__c;
                            skillsAndValue.put(s.Category__c, existingSkillValue);
                        }
                    }
                }
            }
       }//outer for ends
       system.debug(skillsAndValue);
        
        
       //normalize wights:grade ratio to 100:x
       Decimal temp = 0;
       for (String key: skillsAndValue.keySet()){
			 existingSkillValue = skillsAndValue.get(key);
           	 if (existingSkillValue[0] != 0){ 
                 temp = existingSkillValue[0];
                 existingSkillValue[0] = 100;
                 existingSkillValue[1] = (100/temp)*existingSkillValue[1];
                 skillsAndValue.put(key, existingSkillValue);
                 system.debug('run in');
             }
             system.debug('run out from key ' + key);
       }
       system.debug(skillsAndValue);
       return skillsAndValue;
    }//method ends
    
    
    
    
    
    
    
    
    
}