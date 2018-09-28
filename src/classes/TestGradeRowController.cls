@isTest
public class TestGradeRowController {
    @isTest
    public static void getAssessments_test_positive(){
        Assessment__C a = GradeDataFactory.createAssessments(1)[0];
        String subId = a.Subject__c;
        List<Subject__c> subs = new List<Subject__c>{[SELECT id FROM Subject__c WHERE  ID = :subId]};
        List<Id> ids = GradeRowController.getAssessments(a.Trainee__c,a.Week__c, subs);
        system.debug(ids);
        system.assert(ids.contains(a.Id));
        
    }
    @isTest
    public static void getAssessments_test_negative(){
        List<Week__c> weeks = GradeDataFactory.createWeeks(5);
        List<Training__c> trains = GradeDataFactory.createTrainings(5);
        List<Contact> trainees = GradeDataFactory.createContacts(5);
        List<Subject__c> emptySubs = GradeDataFactory.createSubjects(5);
        List<Subject__c> el = new List<Subject__C>();
        for(Integer i = 0; i < trainees.size(); i++){
          List<Id> emptyIds = GradeRowController.getAssessments(trainees[i].id,weeks[i].id, emptySubs);
          //List<Id> emptyIds2 = GradeRowController.getAssessments(weeks[i].id, trainees[i].id,emptySubs);
          List<Id> emptyIds3 = GradeRowController.getAssessments(trainees[i].id,weeks[i].id, el);
           //system.debug('emptyIds2: ' + emptyIds2);
        }
          List<Id> emptyIds3 = GradeRowController.getAssessments(trainees[0].id,weeks[0].id, el);
                  system.assert(emptyIds3.size() == el.size());

    }
}