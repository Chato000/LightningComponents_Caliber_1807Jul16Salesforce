// Created By: 1807Jul18 Salesforce Reston VA
// Last Modified: 2018-09-21
({
	onChange : function(component, event, helper) {
		helper.onChange(component, event, helper);
	},

	onChangeGrade: function(component, event, helper) {
        helper.onChangeGrade(component, event, helper);
	},

	onChangeWithGrade: function(component, event, helper) {
		helper.onChange(component, event, helper);
        helper.onChangeGrade(component, event, helper);
	},
})