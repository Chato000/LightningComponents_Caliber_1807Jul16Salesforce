({
    setupRadarChart : function(component) {                                          
            var radarChartData = {
			labels: ['1st', '2nd', '3rd', '4th', '5th', '6th'],
			datasets: [
               		{ 
                        data: [10,20,30,40,50,60]
                    }
                ]
            }
        console.log('setupRadarChart called  on helper');
      	console.log(radarChartData);
        var el = component.find('radarChart').getElement();
        var ctx = el.getContext('2d');
        new Chart(ctx).Radar(radarChartData);   
    },                                       
})