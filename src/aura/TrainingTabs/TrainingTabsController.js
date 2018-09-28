({
    //function for initializing tabs, calls helper
    initTabs: function(component, event, helper) {
        helper.createTabs(component, event, helper);
    },

    //function to add new weeks, calls controller, recreates tabs with helper
    newWeek: function(component, event, helper) {
        var create = component.get("c.createWeek");
        create.setParams({
            recordId: component.get("v.recordId")
        });

        create.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
            	helper.createTabs(component, event, helper);
            	component.set("v.isOpen", false);
            }
        });
        $A.enqueueAction(create);
    },
    
    //open warning window
    openAlert: function(component, event, helper) {
        component.set("v.isOpen", true);
    },

    //close warning window
    cancel: function(component, event, helper) {
        component.set("v.isOpen", false);
    }
})