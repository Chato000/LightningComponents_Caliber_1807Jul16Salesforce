({
	getRating : function(component) {
		const average = component.get('v.week.Integer_Smilie__c') || component.get('v.average');
		return average > 2.5 ? 3 : average >= 2 ? 2 : 1;
	},

	update : function(component, helper) {
		const rating = helper.getRating(component);
		component.set('v.happyUrl', helper.getUrl(3, rating == 3));
		component.set('v.neutralUrl', helper.getUrl(2, rating == 2));
		component.set('v.sadUrl', helper.getUrl(1, rating == 1));
	},

	getUrl : function(rating, active) {
		return $A.get('$Resource.smiles') + '/smiles/' + rating + (active ? '' : 'dull' ) + '.svg';
	},
	
	override : function(component, helper, rating) {
		component.set('v.week.Integer_Smilie__c', rating);
		component.getEvent('faceOverride').fire();
		helper.update(component, helper);
	}
})