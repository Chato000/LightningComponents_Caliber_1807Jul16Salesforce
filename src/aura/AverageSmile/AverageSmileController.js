({
	onInit : function(component, event, helper){
		helper.update(component, helper);
    },
    
    onChange : function(component, event, helper) {
    	helper.update(component, helper);
    },

    overrideHappy : function (c, e, h) { h.override(c, h, 3); },
    overrideNeutral : function (c, e, h) { h.override(c, h, 2); },
    overrideSad : function (c, e, h) { h.override(c, h, 1); },
})