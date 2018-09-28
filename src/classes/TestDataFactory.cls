@isTest
public class TestDataFactory {
    @isTest 
    public static void createTestRecords() {
        
        List<Training__c> training = new List<Training__c>();
        List<Week__c> SNweekList = new List<Week__c>();
        List<Week__c> SFweekList = new List<Week__c>();
        List<Week__c> JweekList = new List<Week__c>();
        List<Contact> SNConList = new List<Contact>();
        List<Contact> SFConList = new List<Contact>();
        List<Contact> JConList = new List<Contact>();
        List<Subject__c> SNSubjectList = new List<Subject__c>();
        List<Subject__c> SFSubjectList = new List<Subject__c>();
        List<Subject__c> JSubjectList = new List<Subject__c>();
        List<Batch_Assignment__c> baList = new List<Batch_Assignment__c>();
        List<Assessment__c> AssessList = new List<Assessment__c>();
       
        
        List<String> TypeList = new List<String>{'Quiz', 'One_on_One', 'QC'};
        List<String> CategoryList = new List<String>{'Git', 'HTML', 'CSS',
            'JavaScript', 'Java', 'SQL', 'NoSQL', 'Agile', 'Testing', 'Networking'};
        List<String> FirstNames = new List<String>{'Katelyn', 'Gino', 'Karmen', 'Teresia', 'Nelda',
            'Saran', 'Susana', 'Tiffaney', 'Geoffrey', 'Willie', 'Portia', 'Stepanie', 'Dulce', 'Tracie', 'Hai',
            'Carmel', 'Yuriko', 'Gala', 'Mallie', 'Amee', 'Caprice', 'Tammi', 'Carlotta', 'Randell', 'Shari',
            'Kyra', 'Cristy', 'Brittney', 'Anne', 'Donnetta', 'Caterina', 'Flor', 'Raguel', 'Numbers', 'Yelena',
            'Dennis', 'Frederick', 'Shenna', 'Aide', 'Lucio', 'Arnette', 'Korey', 'Danae', 'Isabell', 'Hermina'};
                List<String> FullNames = new List<String>{'Paola', 'Feemster',  'Kermit', 'Noonan', 'Lanelle', 'Tamura', 'Kenton', 'Karp', 'Jodi', 'Audie'  ,'Joette', 'Bidwell', 'Tami', 'Shenk', 'Broderick', 'Backman', 'Shonna', 'Conger', 'Yang', 'Joye' , 'Hilton', 'Dombrosky', 'Tayna', 'Pentz', 
                    'Cole', 'Ceasar', 'Leland', 'Nieman',  'Marg', 'Hollister',  'Dacia', 'Ruble',  'Rivka', 'Morphew',  'Georgie', 'Dennen',  'James', 'Quinney',  'Russel', 'Mill',  'Hipolito', 'Burge',  'Bethanie', 'Difranco',  'Blanche', 'Tope',  'Erwin', 'Mayberry',  'Josefina', 'Baxendale',  
                    'Larita', 'Boydstun',  'Duncan', 'Willaims',  'Grazyna', 'Reaux',  'Soon', 'Greenman',  'Willie', 'Helberg',  'Alene', 'Kimbell',  'Brett', 'Perkins',  'Nannie', 'Malsam',  'Tomas', 'Taketa',  'Sook', 'Erne',  'Jackelyn', 'Marland',  'Loris', 'Hammontree',  'Rene', 'Rodas',  
                    'Stephen', 'Benninger',  'Sacha', 'Wall',  'Vern', 'Odonnel',  'Liana', 'Maiorano',  'Enedina', 'Findley', 'Caprice', 'Dombroski',  'Eleni', 'Haff',  'Frederic', 'Hart',  'Hong', 'Rapoza',  'Merlene', 'Slaten',  'Margart', 'Antes',  'Brooke', 'Licht'};
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String chars2 = 'abcdefghijklmnopqrstuvwxyz';
        
        
       	Training__c a = new Training__c(Name='18 01 Jan 03 ServiceNow', training_track__c = 'a060b00001OepoYAAR', trainer__c = '0050b000005R4JZAA0', Start_Date__c = Date.newInstance(2018, 1, 3), End_Date__c = Date.newInstance(2018, 4, 15));
        Training__c b = new Training__c(Name='18 04 Apr 18 Salesforce', training_track__c = 'a060b00001OeztmAAB', trainer__c = '0050b000005R30lAAC', Start_Date__c = Date.newInstance(2018, 4, 18), End_Date__c = Date.newInstance(2018, 7, 24));
       	Training__c c = new Training__c(Name='17 02 Feb 12 Java', training_track__c = 'a060b00001Of9l3AAB', trainer__c = '0050b000005RA4sAAG', Start_Date__c = Date.newInstance(2017, 2, 12), End_Date__c = Date.newInstance(2018, 5, 19));
        
        training.add(a);
        training.add(b);
        training.add(c);
      
        insert training;
        system.assert(training.size() == 3, 'The training does not exist!');
        
        for(Integer i=1; i<=3; i++){
            for(Integer j=1; j<=10;j++){
                Week__c w = new Week__c();
                w.Week_Number__c = String.valueOf(j);
                if(i==1){
                    w.Name = 'Week ' + String.valueOf(j) + ' a';
                    w.Training__c = a.Id;
                    SNWeekList.add(w);
                    System.debug(w.Name + ' has been added to SNWeekList');
            	}
                if(i==2){
                    w.Name = 'Week ' + String.valueOf(j) + ' b';
                    w.Training__c = b.id;
                    SFWeekList.add(w);
                }
                if(i==3){
                    w.Name = 'Week ' + String.valueOf(j) + ' c';
                    w.Training__c = c.id;
                    JWeekList.add(w);
                }
        	}
        }
        Insert SNWeekList;
        system.assert(SNWeekList.size() == 10, 'The ServiceNow training does not have 10 weeks!');
        Insert SFWeekList;
        system.assert(SFWeekList.size() == 10, 'The Salesforce training does not have 10 weeks!');
        Insert JWeekList;
        system.assert(JWeekList.size() == 10, 'The Java training does not have 10 weeks!');
        
        for(Integer i=1; i<=3; i++){
            for(Integer j=1; j<=15;j++){
                Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), FullNames.size());
                Integer idx2 = Math.mod(Math.abs(Crypto.getRandomInteger()), FullNames.size());
                Contact con = new Contact();
                con.FirstName = FullNames[idx];  //chars.substring(idx, idx+1);
                con.LastName = FullNames[idx2]; //chars.substring(idx, idx+1) + chars2.substring(idx, idx+3);
                if(i==1){
                    SNConList.add(con);
                    System.debug(con.FirstName + con.LastName + ' has been added to the ServiceNow contact list');
                }
                if(i==2){
                    SFConList.add(con);
                }
                if(i==3){
                    JConList.add(con);
                }
            }
        }
        Insert SNConList;
        system.assert(SNConList.size() == 15, 'The ServiceNow training does not have 15 trainees!');
        Insert SFConList;
        system.assert(SNConList.size() == 15, 'The Salesforce training does not have 15 trainees!');
        Insert JConList;
        system.assert(SNConList.size() == 15, 'The Java training does not have 15 trainees!');
        
        for(Integer i=1; i<=3; i++){
            for(Integer j=1; j<=15; j++){
              	Batch_Assignment__c ba = new Batch_Assignment__c();
                if(i==1){
					ba.Trainee__c = SNConlist[j-1].id;
                    ba.Training__c = a.Id;
                    system.debug(SNConlist[j-1].FirstName + ' ' + SNConlist[j-1].LastName  + ' has been added to Batch Assignment list.' );
            	}
                if(i==2){
					ba.Trainee__c = SFConlist[j-1].id;
                    ba.Training__c = b.id;
                }
                if(i==3){
					ba.Trainee__c = JConlist[j-1].id;
                    ba.Training__c = c.id;
                }
                baList.add(ba);
            }
        }
        insert baList;
        
        for (Integer i=1; i<=3; i++) {
  			for (Integer j=1; j<=10; j++) {
            	if (i == 1) {
                	Subject__c sub1 = new Subject__c(Type__c = Typelist[0], Category__c = CategoryList[j-1], Week__c = SNWeekList[j-1].id, weight__c = 400);
                    Subject__c sub2 = new Subject__c(Type__c = Typelist[1], Category__c = CategoryList[j-1], Week__c = SNWeekList[j-1].id, weight__c = 600);
                    Subject__c sub3 = new Subject__c(Type__c = Typelist[2], Week__c = SNWeekList[j-1].id);
                    SNSubjectList.add(sub1);
                    SNSubjectList.add(sub2);
                    SNSubjectList.add(sub3);
                    system.debug('Subject of type ' + String.valueof(sub1.Type__c) + ' and category ' + String.valueOf(sub1.Category__c) + ' has been added to ' + SNWeekList[j-1].name + ' ' + String.valueOf(sub1.Week__c));
                }
                if (i == 2) {
                	Subject__c sub1 = new Subject__c(Type__c = Typelist[0], Category__c = CategoryList[j-1], Week__c = SFWeekList[j-1].id, weight__c = 400);
                    Subject__c sub2 = new Subject__c(Type__c = Typelist[1], Category__c = CategoryList[j-1], Week__c = SFWeekList[j-1].id, weight__c = 600);
                    Subject__c sub3 = new Subject__c(Type__c = Typelist[2], Week__c = SFWeekList[j-1].id);
                    SFSubjectList.add(sub1);
                    SFSubjectList.add(sub2);
                    SFSubjectList.add(sub3);
                }
                if (i == 3) {
                    Subject__c sub1 = new Subject__c(Type__c = Typelist[0], Category__c = CategoryList[j-1], Week__c = JWeekList[j-1].id, weight__c = 400);
                    Subject__c sub2 = new Subject__c(Type__c = Typelist[1], Category__c = CategoryList[j-1], Week__c = JWeekList[j-1].id, weight__c = 600);
                    Subject__c sub3 = new Subject__c(Type__c = Typelist[2], Week__c = JWeekList[j-1].id);
                    JSubjectList.add(sub1);
                    JSubjectList.add(sub2);
                    JSubjectList.add(sub3);        
                }
  			} 
    	}
        insert SNSubjectList;
        system.assert(SNSubjectList.size() == 30, 'The ServiceNow training does not have 30 subjects!');
        insert SFSubjectList;
        system.assert(SFSubjectList.size() == 30, 'The Salesforce training does not have 30 subjects!');
        insert JSubjectList;
        system.assert(JSubjectList.size() == 30, 'The Java training does not have 30 subjects!');
        
        for (Integer i=1; i<=3; i++) {
  			for (Integer j=1; j<=10; j++) {
                for(Integer k=1; k<=15; k++){
                    Decimal QuizScore = math.random()*100;
                    Decimal OneScore = math.random()*100;
                    Quizscore = Quizscore.setScale(2);
                    OneScore = OneScore.setScale(2);
                    Double random = Math.floor(Math.random()*4)+1;
                    if (i == 1) {                        
                        Assessment__c assess1 = new Assessment__c(Subject__c=SNSubjectList[(j-1)*3].id, Week__c=SNWeekList[j-1].id, trainee__c=SNConList[k-1].id, grade__c=QuizScore);
                        Assessment__c assess2 = new Assessment__c(Subject__c=SNSubjectList[((j-1)*3)+1].id, Week__c=SNWeekList[j-1].id, trainee__c=SNConList[k-1].id, grade__c=OneScore);
                        Assessment__c assess3 = new Assessment__c(Subject__c=SNSubjectList[((j-1)*3)+2].id, Week__c=SNWeekList[j-1].id, trainee__c=SNConList[k-1].id, Integer_Smilie__c = random);
                        AssessList.add(assess1);
                        AssessList.add(assess2);
                        AssessList.add(assess3);
                        system.debug('Assess1 has a quiz score of ' + assess1.Grade__c + ' and assess 2 has a one on one score of ' + assess2.grade__c + ' at J = ' + string.valueOf(j) + ' and at k = ' + string.valueof(k));
                    }
                    if (i == 2) {
                        Assessment__c assess1 = new Assessment__c(Subject__c=SFSubjectList[(j-1)*3].id, Week__c=SFWeekList[j-1].id, trainee__c=SFConList[k-1].id, grade__c=QuizScore);
                        Assessment__c assess2 = new Assessment__c(Subject__c=SFSubjectList[((j-1)*3)+1].id, Week__c=SFWeekList[j-1].id, trainee__c=SFConList[k-1].id, grade__c=OneScore);
                        Assessment__c assess3 = new Assessment__c(Subject__c=SFSubjectList[((j-1)*3)+2].id, Week__c=SFWeekList[j-1].id, trainee__c=SFConList[k-1].id, Integer_Smilie__c = random);
                        AssessList.add(assess1);
                        AssessList.add(assess2);
                        AssessList.add(assess3);
                        
                    }
                    if (i == 3) {
                        Assessment__c assess1 = new Assessment__c(Subject__c=JSubjectList[(j-1)*3].id, Week__c=JWeekList[j-1].id, trainee__c=JConList[k-1].id, grade__c=QuizScore);
                        Assessment__c assess2 = new Assessment__c(Subject__c=JSubjectList[((j-1)*3)+1].id, Week__c=JWeekList[j-1].id, trainee__c=JConList[k-1].id, grade__c=OneScore);
                        Assessment__c assess3 = new Assessment__c(Subject__c=JSubjectList[((j-1)*3)+2].id, Week__c=JWeekList[j-1].id, trainee__c=JConList[k-1].id, Integer_Smilie__c = random);
                        AssessList.add(assess1);
                        AssessList.add(assess2);
                        AssessList.add(assess3);
                    }
                }
  			} 
    	}
        insert AssessList;
        system.assert(AssessList.size() == 1350, 'AssessList is not 1350!');
        
        Room_Assignment__c RA1 = new Room_Assignment__c(Training__c = a.id, Room__c = 'a070b00000lzqzKAAQ', Start_Date__c = Date.newInstance(2018, 1, 3), End_Date__c = Date.newInstance(2018, 4, 15));
        Room_Assignment__c RA2 = new Room_Assignment__c(Training__c = b.id, Room__c = 'a070b00000lzqzPAAQ', Start_Date__c = Date.newInstance(2018, 4, 18), End_Date__c = Date.newInstance(2018, 7, 24));
        Room_Assignment__c RA3 = new Room_Assignment__c(Training__c = c.id, Room__c = 'a070b00000lzqzZAAQ', Start_Date__c = Date.newInstance(2017, 2, 12), End_Date__c = Date.newInstance(2018, 5, 19));
    }
}