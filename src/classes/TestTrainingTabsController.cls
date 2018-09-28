@isTest
public class TestTrainingTabsController {

    @isTest
    public static void getWeeks_test_positive(){
       List<Training__c> tList = GradeDataFactory.createTrainings(10); 
        for(Training__c train : tList){
           system.assertNotEquals(null, TrainingTabsController.getWeeks(train.id));
        }
    }
    @isTest
    public static void createWeek_test_postitive(){
       List<Training__c> tList = GradeDataFactory.createTrainings(10); 
        for(Training__c train: tList){
        system.assertNotEquals(null, TrainingTabsController.createWeek(train.id));
        }
        
    }
}