({
	//create tabs, gets tab information using apex controller
	createTabs : function(component, event, helper) {
		var action = component.get("c.getWeeks");
		action.setParams({recordId: component.get("v.recordId")});
		
		action.setCallback(this, function(response) {
			if (response.getState() == "SUCCESS") {
				component.set("v.weeks", response.getReturnValue());
			}
		});
		
		$A.enqueueAction(action);
	}
})