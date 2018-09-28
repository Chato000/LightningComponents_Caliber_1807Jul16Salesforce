({
	
	 doInit: function(component, event, helper) {
         component.set("v.thisYear", (new Date()).getFullYear());
         component.set("v.thisQuarter", 'Q'+ ((new Date()).getMonth()+1)/3); // ((new Date()).getMonth()+1)/3 - This returns numeric value of current quarter
         var action = component.get("c.returnInitData"); //returnInitData returns list of list, 1st list for years, 2nd list for Q' 
         action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS"){
               var filteringData = response.getReturnValue()
               console.log(filteringData);
               component.set("v.years", filteringData[0]);
               component.set("v.quarters", filteringData[1]);
                
               //calling getBatches
                component.find("yearSelection").set("v.value", component.get("v.thisYear"));
                component.find("quarterSelection").set("v.value", component.get("v.thisQuarter"));
                var a = component.get('c.getBatches');
                $A.enqueueAction(a);  
            }else {
                console.log("Failed at doInit method with state: " + state);
            }
        })
        $A.enqueueAction(action);
        //In order to show a specific inputSelectOption, it has to have value="true"
        //for Example, even if item "2018" on yearSelection set to show on default, the curretn value of the inputSelectionList is null,
        //until user actually click the dropdown and manually selects it. Hence, component.find("yearSelection").get("v.value") will still return null.
        //Just b/c a value is showing on the picklist as default doesnt actually mean it's selected. weird!
        //JS code can also update current valeu of that inputSelection to a different value, even though doin that will change the current selected option in the code
        //it wont update the UI. 
        //for example, if the current year is "2018" and component.find("yearSelection").set("v.value", "2017") runs. it changed the current value of the picklist, but
        //it will not update the UI to show 2017 has been selected. (it'd still show 2018) 
    	}
,
    
     getBatches: function(component, event, helper){ //get initial data for component, such as years, and quarters.
        console.log("getBatches JS function called");
        var action = component.get("c.returnBatches");
        action.setParams({yr:component.find("yearSelection").get("v.value"), quarter:component.find("quarterSelection").get("v.value").charAt(1)});
        //console.log(component.find("quarterSelection").get("v.value").charAt(1)});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS"){
                var filteringData = [];
                filteringData = response.getReturnValue();
                console.log(filteringData);
                /*let batchName = [];
                for (let i=0; i< filteringData.length; i++){
                    batchName[i] = filteringData[i].Name;
                }*/
                //console.log(batchName);
                //console.log(typeof(filteringData[0]));
                filteringData.unshift("-Select One-");
                component.set("v.batches", filteringData);
                component.find("batchSelection").set("v.value", filteringData[0]);
            }else {
                console.log("Failed with state: " + state);
            }
        })
        $A.enqueueAction(action);
     }
,
    
    getAssociates: function(component, event, helper){
        if(component.find("batchSelection").get("v.value") != "-Select One-"){
        	console.log("getAssociates JS function called");
            var action = component.get("c.returnAssociatesWithBatchName");
            action.setParams({batchName:component.find("batchSelection").get("v.value")});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state == "SUCCESS"){
                   var filteringData = response.getReturnValue();
                    console.log("getAssociates function response: " + filteringData);
                    filteringData.unshift("-Select One-");
                    component.set("v.associates", filteringData);
                    component.find("associateSelection").set("v.value", "-Select One-");
                    helper.bigBarCall(component);
                    helper.radarDonutCall(component);
                    
                    helper.lineBarCall(component);
                    helper.qcCall(component);
                }else {
                    console.log("Failed with state: " + state);
                }
            })
            $A.enqueueAction(action);
            
            let weekFunction = component.get("c.getWeeks");
            $A.enqueueAction(weekFunction);
        }   
     }
,
    getWeeks:function(component, event, helper){
        if(component.find("batchSelection").get("v.value") != "-Select One-"){
        	console.log("getWeeks JS function called");
            var action = component.get("c.returnWeeksWithBatchName");
            console.log("after apex call");
            action.setParams({ batchName: component.find("batchSelection").get("v.value") });
            console.log("after apex parameters");
            //console.log(component.find("quarterSelection").get("v.value").charAt(1)});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                   var filteringData = response.getReturnValue();
                    console.log(filteringData);
                    filteringData.unshift("-Select One-");
                    component.set("v.weeks", filteringData);
                    component.find("weekSelection").set("v.value", "-Select One-");
                }else {
                    console.log("Failed with state: " + state);
                }
            })
            $A.enqueueAction(action);
        }
    }

,    
    
    weekHandler : function(component, event, helper) {
        
        if (component.find("associateSelection").get("v.value") == "-Select One-") {
            helper.bigBarByWeekCall(component);
            //fire helper.radarDonutByWeekCall(component);
            //fire helper.lineBarByWeekCall(component);
            //fire helper.qcByWeekCall(component);
            //fire helper.assessmentByWeekCall(component);
        } else {
            //fire helper.bigBarByAssociateCall(component);
            //fire helper.radarDonutByAssociateCall(component);
            //fire helper.lineBarByAssociateCall(component);
            //fire helper.qcByAssociateCall(component);
        }
            
    },
    
    associateHandler : function(component, event, helper) {
        
    	if (component.find("weekSelection").get("v.value") == "-Select One-") {
            //fire helper.bigBarByAssociateCall(component);
            //fire helper.radarDonutByAssociateCall(component);
            //fire helper.lineBarByAssociateCall(component);
            //fire helper.qcByAssociateCall(component);
        } else {
            //fire helper.bigBarByAssociateWeekCall(component);
            //fire helper.radarDonutByAssociateWeekCall(component);
            //fire helper.lineBarByAssociateWeekCall(component);
            //fire helper.qcByAssociateCall(component);
        }
        
    },
    
    debugButton:function(component, event, helper){
        console.log("Debug:--------------------------------------------------------------");
        console.log("Selected Year: " +  component.find("yearSelection").get("v.value") );
        console.log("Selected Quarter: " + component.find("quarterSelection").get("v.value"));
        console.log("batch selection: " + component.find("batchSelection").get("v.value")); 
        //console.log(" Associate Selection: "+ component.find("associateSelection").get("v.value"));
        //console.log(" Week selection: " + component.find("weekelection").get("v.value"));

    }
     	
})