({
	bigBarChart : function(component, chartVals, chartName, colors){
	/*console.log("inside Chart method");
    console.log(component.get("v.chartNames"));
    console.log(component.get("v.chartVals"));*/	
	var ctx = component.find("bigBarChart").getElement();
	var Chart1 = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartName, 
            datasets: [{
                label: 'Batch Running Averages',
                data: chartVals,
                backgroundColor: colors,
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero:true
                    }
                }]
            }
        }
	});
        
	},
    
    radarChart : function(component, dataSet) {
        let rdr = component.find("radarDountChart").getElement();
		let chart2 = new Chart(rdr, {
            type: 'radar',
            data: {
                labels: dataSet.label,
                datasets: [{
                    label: "Running Averages by Subject",
                    data: dataSet.data,
                    backgroundColor: [
                        "rgba(66, 140, 244, .3)"
                    ],
                    borderColor: [
                    	"rgba(66, 140, 244, 1)"  
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scale: {
                    ticks: {
                        beginAtZero: true, 
                        max: 100
                    }
                }
            }
		});
        
    },
    
    donutChart : function(component) {
        
        
        
    },
    
    lineChart : function(component, dataset) {
    var ctx = component.get('v.lineBarChart').getElement();
    var myLineChart = new Chart(ctx, {
    type: 'line',
    data: dataset.data,
    options: options
	});
        
        
    },
    
    littleBarChart : function(component) {
        
        
        
    },
    
    
    //----------------------------------------Chart/Table methods above | Apex Call methods below-------------------------------------------//
    
    bigBarCall : function(cmp) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.runningAverageForBatch");
       
      
        action.setParams({ batchName : cmp.find("batchSelection").get("v.value") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = JSON.stringify(response.getReturnValue());
                //alert("From server: " + resp);
              
                var parsedResp = JSON.parse(resp);
				let chartVals = [];
                let chartName = [];
                let colors = [];
         
                for (let x = 0; x < parsedResp.length; x++) {
                    chartVals.push(Math.round(parsedResp[x].average * 100) / 100);
                    chartName.push(parsedResp[x].trainee.Name);
                    colors.push("rgba(66, 140, 244, 1)");
                }
                
                cmp.set("v.barChartVals", chartVals);
				cmp.set("v.barChartNames", chartName);
                
               //$A.enqueueAction(cmp.get('c.chart'));
               this.bigBarChart(cmp, chartVals, chartName, colors);
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
        $A.enqueueAction(action);
    },
    
    bigBarByWeekCall : function(component) {

        var action = component.get("c.runningAverageForBatchWeek");
       
        action.setParams({ batchName : component.find("batchSelection").get("v.value"), week: component.find("weekSelection").get("v.value") });

        action.setCallback(this, (response) => {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = JSON.stringify(response.getReturnValue());
              
            	console.log(resp);
            
                var parsedResp = JSON.parse(resp);
				let chartVals = [];
                let chartName = [];
                let colors = [];
         
                for (let x = 0; x < parsedResp.length; x++) {
                    chartVals.push(Math.round(parsedResp[x].average * 100) / 100);
                    chartName.push(parsedResp[x].trainee.Name);
                    colors.push("rgba(66, 140, 244, 1)");
                }
                
                component.set("v.barChartVals", chartVals);
				component.set("v.barChartNames", chartName);
                
               this.bigBarChart(component, chartVals, chartName, colors);
            }
            else if (state === "INCOMPLETE") {
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
        $A.enqueueAction(action);
        
    },
    
    bigBarByAssociateCall : function(component) {
        
        
        
    },
    
    bigBarByAssociateWeekCall : function(component) {
        
        
        
    },
    
    radarDonutCall : function(component) {
     
        var action = component.get("c.returnRadarData");
       
      
        action.setParams({ batchName : component.find("batchSelection").get("v.value") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = JSON.stringify(response.getReturnValue());
                console.log("From server: " + resp);
              
                var parsedResp = JSON.parse(resp);
                let dataSet = {
                    label: [],
                    data: []
                };
         
                for (let key in parsedResp) {
                    dataSet.label.push(key);
                    dataSet.data.push(Math.round(parsedResp[key][1] * 100) / 100);
                }
                
                console.log(dataSet);
                
                component.set("v.radarChartVals", dataSet.data);
				component.set("v.radarChartNames", dataSet.label);
                
                this.radarChart(component, dataSet);
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
        $A.enqueueAction(action);
        
    },
    
    radarDonutByWeekCall : function(component) {
        
        
        
    },
    
    radarDonutByAssociateCall : function(component) {
        
        
        
    },
    
    radarDonutByAssociateWeekCall : function(component) {
        
        
        
    },
    
    lineBarCall : function(component) {
        
        
        
    },
    
    lineBarByWeekCall : function(component) {
        
        
        
    },
    
    lineBarByAssociateCall : function(component) {
        
        
        
    },
    
    lineBarByAssociateWeekCall : function(component) {
        
        
        
    },
    
    qcCall : function(component) {
        
        let action = component.get("c.getQCTableData");
        action.setParams({batchSelect: component.find("batchSelection").get("v.value")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
				
                console.log(resp.traineeData);
                let traineeValues = [];
                traineeValues = Object.values(resp.traineeData);
                
                for (let i = 0; i < traineeValues.length; i++) {
                    for(let c = 0; c < resp.tableHeaders.length - 1; c++) {
                        traineeValues[i][c] = this.getUrl(traineeValues[i][c]);
                    }
                }
                
                for (let i = 0; i < traineeValues.length; i++) {
                    traineeValues[i].unshift(resp.traineeName[i]);
                }
                
                traineeValues[traineeValues.length - 1].splice(0, 1, "Overall");
                
                console.log(traineeValues);
                
                component.set("v.tableHeaders", resp.tableHeaders);
                component.set("v.traineeName", resp.traineeNames);
                component.set("v.traineeValues", traineeValues);
            }
            else if (state === "INCOMPLETE") {
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
        $A.enqueueAction(action);
        
    },
    
    qcByWeekCall : function(component) {
        
        
        
    },
    
    qcByAssociateCall : function(component) {
        
        
        
    },

	getUrl : function(rating) {
		return $A.get('$Resource.smiles') + '/smiles/' + rating + '.svg';
	}
})