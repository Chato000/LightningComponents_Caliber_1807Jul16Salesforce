({
    //Initiation function that uses all 3 helper functions
    //to get rating, set the url, and finally fire the facechanged event
	doInit : function(component, evet, helper){
		const rating = helper.getRating(component); 
		component.set("v.url", helper.getUrl(rating)); 
		helper.reportRating(component, rating); 
    },
    
    //JS controller function that changes to scalable vector image on click
    changeFace : function(component, event, helper) {
        var Rate = helper.getRating(component); 
        if(Rate==0){ //change rate to a different value
            Rate = 4; 
        }
        else{ 
            Rate = Rate - 1;  
        }
        component.set("v.url", helper.getUrl(Rate)); //set the attribute url to display the proper image                    
        component.set("v.subAssessment.Integer_Smilie__c", Rate); 
        component.getEvent("onchange").fire(); //fire onchange event
        helper.reportRating(component, Rate); 
	},
})