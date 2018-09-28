public class radarAndDonutChart{
    
    /* Author: Abu Bakkar Shohag
     * The following method returns a map in the following format- map[key:JAVA, val: ({sumOfTotalWightForAllJavaSubject},{sumOfTotalWeightedGrade})]
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
        //system.debug(weeks);
        
        //subject
        list<subject__c> subjects = [select Category__c, weight__c, week__c from subject__c where Category__c != null and weight__c !=null and Week__c IN: weeksID];
        //system.debug(subjects);
        
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
       //system.debug(assessments);
       
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
                            existingSkillValue[1] = existingSkillValue[1] + (s.Weight__c/100) * a.Grade__c;
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
                 //system.debug('run in');
             }
             //system.debug('run out from key ' + key);
       }
       system.debug(skillsAndValue);
       return skillsAndValue;
    }//method ends
	
    
    
    /* The following method returns a map for QC smiley count.
	 * each key(represent a smileyvalue from 0-4), value represent the count.
     * This method will not ignore: Assignment__c with integer_smilie__c != null
       Each key represent the following:
		0 - ? (QC wasn't performed for this specific trainee)
        1 - sad
        2 - nutral
        3 - happy 
        4 - excellent
     */
    
    @AuraEnabled
    public static Map<Integer, Integer> returnDonutData(String batchName){
        Map <Integer, Integer> result = new Map <Integer, Integer>();
        result.put(0, 0);
        result.put(1, 0);
        result.put(2, 0);
        result.put(3, 0);
        result.put(4, 0);
    	//starting query
        //weeks
        list<Week__c> weeks = [Select id, training__r.Name from week__c where training__r.name = :batchName];
        list<ID> weeksID = new list<ID>();
        for (week__c w: weeks){
             weeksID.add(w.id);
        }
        system.debug(weeks);
        
       //assessment
       list<assessment__c> assessments = [select id, grade__c, week__c, subject__c, integer_smilie__c from assessment__c where week__c IN: weeksID and integer_smilie__c != null and recordType.name = 'QC'];
       system.debug(assessments);
        
       for(Integer x: result.keySet())
           for(assessment__c a: assessments){
               if(a.Integer_Smilie__c == x){
                   result.put(x, (result.get(x)+1));
               }
           }
       system.debug(result); 
       return result;
    }
    
}