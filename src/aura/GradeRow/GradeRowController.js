// Created By: 1807Jul18 Salesforce Reston VA
// Last Modified: 2018-09-21

({
	/* perform component initialization
		retrieves assessment data from SFDC (Assessment__c)
		populates component attributes
	 */
	doInit : function(component, event, helper) {
		const getAssessments = component.get('c.getAssessments');
		getAssessments.setParams({
			traineeId : component.get('v.traineeId'),
			subjects : component.get('v.subjects'),
			weekId : component.get('v.weekId')
		});
		getAssessments.setCallback(this, (response) => {
			if (response.getState() === "SUCCESS") {
				component.set('v.assessments', response.getReturnValue());
			} else {
				// TODO: error handling
			}
		})
		$A.enqueueAction(getAssessments);
	}
})