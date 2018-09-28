// Created By: 1807Jul18 Salesforce Reston VA
// Last Modified: 2018-09-21
({
	/* perform component initialization
		retrieves WeekData from SFDC (Subject__c, Contact)
		populates component attributes
	 */
	initialize : function(component, helper) {
		const getSubs = component.get('c.getWeekData');
		const weekId = component.get('v.weekId');
		const weekIdHash = [...weekId.substring(10, 15)].reduce((a, b) => b.charCodeAt(0) + (a * 62), 0);
		getSubs.setParams({ weekId: weekId, forQC: component.get('v.forQC') });
		getSubs.setCallback(this, (response) => {
			if (response.getState() === "SUCCESS") {
				const weekData = response.getReturnValue();
				component.set('v.subjects', weekData.subjects);
				component.set('v.qcSubjectList', weekData.qcSubjectList.join(', '));
				component.set('v.trainees', []); // ugly hack to convince aura to rerender the iteration
				component.set('v.trainees', component.get('v.forQC') ? helper.shuffle(weekData.trainees, weekIdHash) : weekData.trainees);
				component.set('v.totalWeight', weekData.subjects.map((s) => s.Weight__c).reduce((a, b) => isNaN(b) ? a : a + b, 0));
			} else {
				// TODO: error handling
			}
		});
		$A.enqueueAction(getSubs);
	},

	shuffle : function(list, seed) {
		list = [...list];

        // http://indiegamr.com/generate-repeatable-random-numbers-in-js/
		function seededRandom(max, min) {
			max = max || 1;
			min = min || 0;
 
			seed = (seed * 9301 + 49297) % 233280;
			var rnd = seed / 233280;

			return Math.floor(min + rnd * (max - min));
		}

		// https://bost.ocks.org/mike/shuffle/
		function shuffle(array) {
			var m = array.length, t, i;

			while (m) {
				i = seededRandom(0, m--);
				t = array[m];
				array[m] = array[i];
				array[i] = t;
			}
			return array;
		}

		return shuffle(list);
	},

	/*
		Display modal dialog for creating/editing an assessment(Subject__c)
	 */
	addSubject: function(component, event, helper, subId) {
		$A.createComponent("c:CreateAssessmentModal", {
			weekId: component.get('v.weekId'),
			subjectId: subId,
		},
           function(content, status) {
               if (status === "SUCCESS") {
                   component.find('overlayLib').showCustomModal({
                       header: "New Assessment",
                       body: content,
                       closeCallback: () => helper.initialize(component, helper)
                   }).then(modal => content.set('v.modal', modal));
               }                               
           });
	},

	/*
		compute average QC score, excluding ? values
	 */
	computeAverage : function(faceMap) {
		let count = 0;
		let total = 0;
		for (const id in faceMap) {
			const rating = faceMap[id];
			if (rating) {
				++count;
				total += rating;
			}
		}
		return count ? (total / count) : 0;
	},

	/*
		compute assessment score averages with weighting
	*/
	computeAverages : function(component, gradeMap) {
		const averages = {};
		for (const id in gradeMap) {
			const gs = gradeMap[id]; // [Grade, SubjectId]
			averages[gs[1]] = (averages[gs[1]] || 0) + (Number(gs[0]) || 0);
		}

		const numTrainees = component.get('v.trainees').length;
		const totalWeight = component.get('v.totalWeight');
		const subjects = component.get('v.subjects');

		let overallAverage = 0;
		let averageDisplays = component.find('::AVG');
		subjects.forEach((s, i) => {
			const avg = averages[s.Id] / numTrainees / 100;
			if (averageDisplays[i])
				averageDisplays[i].set('v.value', avg);
			overallAverage += (avg * s.Weight__c / totalWeight) || 0;
		});
		component.set('v.gradeAverage', overallAverage);
		if (averageDisplays[averageDisplays.length - 1])
			averageDisplays[averageDisplays.length - 1].set('v.value', overallAverage);
	}
})