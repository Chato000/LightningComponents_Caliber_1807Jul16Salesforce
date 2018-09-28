// Created By: 1807Jul18 Salesforce Reston VA
// Last Modified: 2018-09-21
({
	// init event handler
	doInit : function(component, event, helper) {
		helper.initialize(component, helper);
	},

	// "Add Subject" button onclick handler
	addSubject: function(component, event, helper) {
		helper.addSubject(component, event, helper);
	},

	// utility:settings iconbutton onclick handler
	modSubject: function(component, event, helper) {
		helper.addSubject(component, event, helper, event.getSource().get('v.value'));
	},

	// gradeChange event handler
	averageGrades : function(component, event, helper) {
		if (component.get('v.forQC'))
			return;
		const gradeMap = component.get('v.gradeMap');
		gradeMap[event.getParam('id')] = [event.getParam('rating'), event.getParam('subjectId')];
		helper.computeAverages(component, gradeMap);		
		component.set('v.gradeMap', gradeMap);
	},

	// faceChange event handler
	averageFaces : function(component, event, helper) {
		const faceMap = component.get('v.faceMap');
		faceMap[event.getParam('id')] = event.getParam('rating');
		component.set('v.faceAverage', helper.computeAverage(faceMap));
		component.set('v.faceMap', faceMap);
	},

	// PleaseCloseModalEvent handler
	closeModal: function(component, event, helper) {
		const modal = component.get('v.currentModal');
		if (modal) {
			modal.close();
			component.set('v.currentModal', undefined);
		}
	},

	// onchange handler for Week__c fields (notes, overall smilie override, etc.)
	onChange : function(component, event, helper) {
		component.find('recordData').saveRecord(() => {}); // TODO: error handling
	}
})