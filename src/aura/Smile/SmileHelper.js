({
    //get a record's integer smiley field
	getRating : function(component) {
		return component.get("v.subAssessment.Integer_Smilie__c") || 0;
	},
	
    //get a file path to fetch the png from the zip file static resource
	getUrl : function(rating) {
		return $A.get('$Resource.smiles') + '/smiles/' + rating + '.svg';
	},
    
    //get facechange event and fire the event
	reportRating : function(component, rating) {
        const faceChanged = component.getEvent('faceChange');
        faceChanged.setParams({id: component.get('v.subAssessment.Id'), rating: rating});
        faceChanged.fire();
	}
})