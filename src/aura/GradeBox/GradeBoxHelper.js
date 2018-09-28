// Created By: 1807Jul18 Salesforce Reston VA
// Last Modified: 2018-09-21
({
	// save record data
	onChange : function(component, event, helper) {
		component.find('recordData').saveRecord(() => {}); // TODO: error handling
	},

	// alert parent component of grade change
	onChangeGrade: function(component, event, helper) {
		const fce = component.getEvent('gradeChange');
		fce.setParams({
			id: component.get('v.assessmentId'),
			rating: component.get('v.assessment.Grade__c'),
			subjectId: component.get('v.assessment.Subject__r.Id'),
		});
		fce.fire();
	}
})