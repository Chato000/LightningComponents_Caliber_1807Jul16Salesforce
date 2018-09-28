public with sharing class GradeGridController {
	// Subject__c.Type__c values for which grades should not be displayed 
    public static final String[] specialTypes = new String[]{'QC', 'Notes', 'QCNotes'};

	// Subject__c fields fetched by all queries
    private static final String fieldSpecs = ' Id, Category__c, Type__c, Weight__c ';
 
    private static Subject__c[] insertIfEmpty(Subject__c[] old, Subject__c nou) {
    	if (old.size() == 0) {
    		old.add(nou);
    		insert old;
    	}
    	return old;
    }

	private static Subject__c[] selectSubjects(Id weekId, String typeQual, String limitOpt) {
		return Database.query('SELECT ' + fieldSpecs
			+ ' FROM Subject__c '
			+ ' WHERE Week__c = :weekId AND '
			+ typeQual
			+ ' ORDER BY CreatedDate ASC '
			+ limitOpt);
	}

	// returns the oldest Subject__c of a given type for a given week
	private static Subject__c[] selectOne(Id weekId, String typeString) {
		return selectSubjects(weekId, ' Type__c = \'' + typeString + '\'', 'LIMIT 1');
	}

	// returns or creates a Subject__c for a given type and week
	private static Subject__c[] getSingletonSubject(Id weekId, String typeString) {
		return insertIfEmpty(
			selectOne(weekId, typeString),
			new Subject__c( Type__c=typeString, Week__c=weekId));
	}

    @auraenabled public static Subject__c[] getSubjects(Id weekId, Boolean forQC) {
        if (forQC)
			return getSingletonSubject(weekId, 'QC');
        else {
	        Subject__c[] subs = selectSubjects(weekId, 'Type__c not in :specialTypes', '');
			subs.addAll(getSingletonSubject(weekId, 'Notes'));
        	return subs;
        }
    }

	// get a deduplicated list of a week's assessment topics 
	// NB: subjects should remain in the order established by getSubjects()
	private static String[] getQcSubList(Id weekId) {
		String[] subset = new String[]{};
		for (Subject__c sub : getSubjects(weekId, false))
			if (sub.Category__c != sub.Type__c
				&& sub.Category__c != null
				&& !subset.contains(sub.Category__c)) {
					subset.add(sub.Category__c);
				}
		return subset;
	}

	// get Id for each Contact being trained in a given week
    @auraenabled public static Id[] getTrainees(Id weekId) {
        Id[] contacts = new Id[]{};
        Id training = [SELECT Id, Training__c FROM Week__c where Id = :weekId][0].Training__c;
        for (Batch_Assignment__c bass : [SELECT Trainee__c FROM Batch_Assignment__c WHERE Training__c = :training ORDER BY Trainee__r.Name])
            contacts.add(bass.Trainee__c);
        return contacts;
    }

	private static Datetime getCreatedDate(Id weekId) {
		return [SELECT CreatedDate FROM Week__c WHERE Id = :weekId][0].CreatedDate;
	}

    @auraenabled public static WeekData getWeekData(Id weekId, Boolean forQC) {
        return new WeekData(getSubjects(weekId, forQC), getTrainees(weekId),
        					getQcSubList(weekId), getCreatedDate(weekId));
    }

    public class WeekData {
        @auraenabled public Subject__c[] subjects;
        @auraenabled public Id[] trainees;
        @auraenabled public String[] qcSubjectList;
        @auraenabled public Datetime created;

        public WeekData(Subject__c[] s, Id[] t, String[] qcsl, Datetime creat) {
            subjects = s;
            trainees = t;
            qcSubjectList = qcsl;
            created = creat;
        }
    }
}