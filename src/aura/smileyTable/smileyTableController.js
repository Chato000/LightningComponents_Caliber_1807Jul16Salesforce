({
    init: function (cmp, event, helper) {
        var action = cmp.get("c.smileyClass");
        action.setParams({ batchname : '18 07 Jul 02 Java Testing' });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                console.log(response);
                
                /*var listOfWeeks = [];
                for(let x = 0; x<response.length; x++){
                    listOfWeeks += response[x];
                }
				var list = [];    */
                
                var columnData = [];
                //var rowData = [];
                for (let i=0; i<response.length;i++){
                    columnData[i] = ({ 
                        				label: response[i].name, 
                        				fieldName:response[i].id , 
                        				type: 'text'});
               	}
                /*for (let i=0; i<response.length;i++){
                    columnData[i] = ({
                        response[i].name: 
                });*/
                component.set("v.mycolumns",columnData );
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        cmp.set('v.mycolumns', columnData);

            cmp.set('v.mydata', [{
                    id: 'a',
                    opportunityName: 'Cloudhub',
                    confidence: 0.2,
                    amount: 25000,
                    contact: 'jrogers@cloudhub.com',
                    phone: '2352235235',
                    trendIcon: 'utility:down'
                },
                {
                    id: 'b',
                    opportunityName: 'Quip',
                    confidence: 0.78,
                    amount: 740000,
                    contact: 'quipy@quip.com',
                    phone: '2352235235',
                    trendIcon: 'utility:up'
            }]);
    },
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            alert("You selected: " + selectedRows[i].opportunityName);
        }
    }
})