public with sharing class QCTableComponent {
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
		List<String> tableHeaders; //the header names
		List<String> traineeName; //name of trainees
		Map<String, List<Decimal>> traineeData; //maps trainees to trainee Data
		
		public QCTable(){
			tableHeaders = new List<String>();
			traineeName = new List<String>();
			traineeData = new Map<String, List<Decimal>>();
		}
		
	}
	@auraEnabled
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
       
       return tableR;
       
    }
    
    
}