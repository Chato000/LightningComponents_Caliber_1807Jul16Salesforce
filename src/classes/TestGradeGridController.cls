@isTest
public class TestGradeGridController {

    @isTest
    public static void getWeekDate_test_posititve(){
        Subject__c[] subs = GradeDataFactory.createSubjects(2);
        id weekId = subs[0].Week__c;
        system.assertNotEquals(null, GradeGridController.getWeekData(weekId,false));
        
    }
   /* @isTest
    public static void getTrainees(){
        
        
    }
    */
    @isTest
    public static void getSubjects_test_negative(){
        Subject__c[] subs = GradeDataFactory.createSubjects(20);
        Contact newGuy = new Contact(lastname='myLastName');
        insert newGuy;
        try{
        Subject__c[] testSubs = GradeGridController.getSubjects(newGuy.id,false);
        }catch(Exception e){
            system.debug('Err');
        }

    }    
    
    @isTest
    public static void getSubjects_test_positive(){
        
        Subject__c[] subs = GradeDataFactory.createSubjects(20);
        id weekId = subs[0].Week__c;
        List<Subject__c> sList = new List<Subject__c>();
        for(Subject__c sub : subs){
            sList.add(sub);
        }
         sList.add(new Subject__c(Category__c='Notes', Type__c='Notes', Week__c=weekId));

        Subject__c[] testSubs = GradeGridController.getSubjects(weekId,false);
        system.debug('Data Factory Size: '+ sList);
        system.debug('Method: '+ testSubs);

        for(Integer i = 0; i<testSubs.size(); i++){
        	 //system.assert(testSubs.contains(subs[0]));
             system.assert(testSubs[i].id != null);
             //system.assert(testSubs[i].Week__c == weekId);
             system.assert(testSubs.size() == sList.size());
        }
      
    }
}