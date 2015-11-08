                    
function stopStream(){
	$.get("stopStream", function(data){
		$( "#autogenMsg" ).text( data ).show().fadeOut( 3000 );
    });       
}                                     
      
function killApp(){
	$.get("killApp", function(data){
		$( "#autogenMsg" ).text( data ).show().fadeOut( 3000 );
    });       
}                       
var hits = {};

var updateHistogram = function() { 
	$.getJSON( "getHeatMap", function(data) {
		var parade = data.heatMap;
		for (var i = 0 ; i<parade.length ; i++)
		    hits[parade[i].state] = parade[i].heatMapColor;	
		 g.selectAll("path")
		 	.style("fill", function(d) { return hits[d.properties.abbr]; });
	});     
	setTimeout(updateHistogram, 1200);
	
};          

setTimeout(updateHistogram, 1000);

var selectedState;

var width = 960,
    height = 500,
    centered;

var projection = d3.geo.albersUsa()
    .scale(width)
    .translate([0, 0]);

var path = d3.geo.path()
    .projection(projection);

var svg = d3.select("#usmap").append("svg")
    .attr("width", width)
    .attr("height", height);

svg.append("rect")
    .attr("class", "background")
    .attr("width", width)
    .attr("height", height)
    .on("click", click);

var g = svg.append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")
  .append("g")
    .attr("id", "states");

d3.json("resources/states.json", function(json) {
  var heatmap = d3.scale.linear()
    .domain([0,d3.max(json.features, function(d) { return Math.log(hits[d.properties.abbr] || 1); })])
    .interpolate(d3.interpolateRgb)
    .range(["#ffffff","#073f07"]);
  
  var states = g.selectAll("path")
    .data(json.features)
    .enter().append("path")
      .attr("d", path)
      .attr("id", function(d) { return d.properties.abbr; })
      .style("fill", function(d) { return heatmap(Math.log(hits[d.properties.abbr] || 1)); })
      .on("click", click);
  
  var labels = g.selectAll("text")
    .data(json.features)
    .enter().append("text")
      .attr("transform", function(d) { return "translate(" + path.centroid(d) + ")"; })
      .attr("id", function(d) { return 'label-'+d.properties.abbr; })
      .attr("dy", ".35em")
      .on("click", click)
      .text(function(d) { return d.properties.abbr; });
});


function click(d) {
  var x = 0,
      y = 0,
      k = 1;

  if ($("#stateOrders").is(':visible')) $("#stateOrders").hide(1000);

  if (d && centered !== d) {
    var centroid = path.centroid(d);
    x = -centroid[0];
    y = -centroid[1];
    k = 4;
    centered = d;
    
    $("#stateOrders").show(1000);

    selectedState = d.properties.abbr;
	chart2.titleText="Activations for "+d.properties.name;

    //chart2.titleText="Orders for "+d.properties.abbr;
	
	/*
	 //This scrolls the page when selecting a state, uncomment if the graph area is under the map
    setTimeout(function(){	  
  	    $('body').animate({
  	        scrollTop: 1000
  	    }, 1000);  
    }, 1500);    
    */
    
  } else {
    centered = null;
  }

  g.selectAll("path")
      .classed("active", centered && function(d) { return d === centered; });
  g.selectAll("text")
      .text(function(d) { return d.properties.abbr; })
      .classed("active",false);
  if (centered) {
      g.select("#label-"+centered.properties.abbr)
          .text(function(d) { return d.properties.name; })
          .classed("active", centered && function(d) { return d === centered; });
  }

  g.transition()
      .duration(1000)
      .attr("transform", "scale(" + k + ")translate(" + x + "," + y + ")")
      .style("stroke-width", 1.5 / k + "px");
}

	var chartRT = function () {
	    var _self = this;

	    function s4() {
	        return Math.floor((1 + Math.random()) * 0x10000)
	            .toString(16)
	            .substring(1);
	    };

	    function guid() {
	        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
	    }

	    _self.guid = guid();
	    _self.DataSeries = [];
	    _self.Ticks = 20;
	    _self.TickDuration = 1000; //1 Sec
	    _self.MaxValue = 100;
	    _self.w = 800;
	    _self.h = 400;
	    _self.margin = {
	        top: 50,
	        right: 90,
	        bottom: 60,
	        left: 0
	    };
	    _self.width = _self.w - _self.margin.left - _self.margin.right;
	    _self.height = _self.h - _self.margin.top - _self.margin.bottom;
	    _self.xText = '';
	    _self.yText = '';
	    _self.titleText = '';
	    _self.chartSeries = {};

	    _self.Init = function () {
	        d3.select('#chart-' + _self.guid).remove();
	        //
	        // Back fill DataSeries with Ticks of 0 value data
	        //
	        /*
	        _self.fillDataSeries = function () {
	            for (Series in _self.DataSeries) {
	                while (_self.DataSeries[Series].Data.length < _self.Ticks +3) {
	                    _self.DataSeries[Series].Data.push({ Value: 0 });
	                }
	            }
	        }
			*/
	        //_self.fillDataSeries();
	        //
	        //  SVG Canvas
	        //
	        _self.svg = d3.select("#stateOrders").append("svg")
	            .attr("id", 'chart-' + _self.guid)
	            .attr("width", _self.w)
	            .attr("height", _self.h)
	            .append("g")
	            //.attr("transform", "translate(" + _self.margin.left + "," + _self.margin.top + ")");
	            .attr("transform", "translate(" + 30 + "," + _self.margin.top + ")");

	        //
	        //  Use Clipping to hide chart mechanics
	        //
	        _self.svg.append("defs").append("clipPath")
	            .attr("id", "clip-" + _self.guid)
	            .append("rect")
	            .attr("width", _self.width)
	            .attr("height", _self.height);
	        //
	        // Generate colors from DataSeries Names
	        //
	        _self.color = d3.scale.category10();
	        _self.color.domain(_self.DataSeries.map(function (d) {
	            return d.Name;
	        }));
	        //
	        //  X,Y Scale
	        //
	        _self.xscale = d3.scale.linear().domain([0, _self.Ticks]).range([0, _self.width]);
	        _self.yscale = d3.scale.linear().domain([0, _self.MaxValue]).range([_self.height, 0]);
	        //
	        //  X,Y Axis
	        //
	        _self.xAxis = d3.svg.axis()
	            .scale(d3.scale.linear().domain([0, _self.Ticks]).range([_self.width, 0]))
	            .orient("bottom");
	        _self.yAxis = d3.svg.axis()
	            .scale(_self.yscale)
	            .orient("left");
	        //
	        //  Line/Area Chart
	        //
	        _self.line = d3.svg.line()
	            .interpolate("basis")
	            .x(function (d, i) {
	            return _self.xscale(i - 1);
	        })
	            .y(function (d) {
	            return _self.yscale(d.Value);
	        });
	        //
	        _self.area = d3.svg.area()
	            .interpolate("basis")
	            .x(function (d, i) {
	            return _self.xscale(i - 1);
	        })
	            .y0(_self.height)
	            .y1(function (d) {
	            return _self.yscale(d.Value);
	        });
	        //
	        //  Title 
	        //
	        _self.Title = _self.svg.append("text")
	            .attr("id", "title-" + _self.guid)
	            .style("text-anchor", "middle")
	            .text(_self.titleText)
	            .attr("transform", function (d, i) {
	            return "translate(" + _self.width / 2 + "," + -10 + ")";
	        });
	        //
	        //  X axis text
	        //
	        _self.svg.append("g")
	            .attr("class", "x axis")
	            .attr("transform", "translate(0," + _self.yscale(0) + ")")
	            .call(_self.xAxis)
	            .append("text")
	            .attr("id", "xName-" + _self.guid)
	            .attr("x", _self.width / 2)
	            .attr("dy", "3em")
	            .style("text-anchor", "middle")
	            .text(_self.xText);
	        //
	        // Y axis text
	        //
	        _self.svg.append("g")
	            .attr("class", "y axis")
	            .call(_self.yAxis)
	            .append("text")
	            .attr("id", "yName-" + _self.guid)
	            .attr("transform", "rotate(-90)")
	            .attr("y", 0)
	            .attr("x", -_self.height / 2)
	            .attr("dy", "-3em")
	            .style("text-anchor", "middle")
	            .text(_self.yText);
	        //
	        // Vertical grid lines
	        //
	        _self.svg.selectAll(".vline").data(d3.range(_self.Ticks)).enter()
	            .append("line")
	            .attr("x1", function (d) {
	            return d * (_self.width / _self.Ticks);
	        })
	            .attr("x2", function (d) {
	            return d * (_self.width / _self.Ticks);
	        })
	            .attr("y1", function (d) {
	            return 0;
	        })
	            .attr("y2", function (d) {
	            return _self.height;
	        })
	            .style("stroke", "#eee")
	            .style("opacity", .5)
	            .attr("clip-path", "url(#clip-" + _self.guid + ")")
	            .attr("transform", "translate(" + (_self.width / _self.Ticks) + "," + 0 + ")");
	        //
	        // Horizontal grid lines
	        //
	        _self.svg.selectAll(".hline").data(d3.range(_self.Ticks)).enter()
	            .append("line")
	            .attr("x1", function (d) {
	            return 0;
	        })
	            .attr("x2", function (d) {
	            return _self.width;
	        })
	            .attr("y1", function (d) {
	            return d * (_self.height / (_self.MaxValue / 10));
	        })
	            .attr("y2", function (d) {
	            return d * (_self.height / (_self.MaxValue / 10));
	        })
	            .style("stroke", "#eee")
	            .style("opacity", .5)
	            .attr("clip-path", "url(#clip-" + _self.guid + ")")
	            .attr("transform", "translate(" + 0 + "," + 0 + ")");
	        //
	        //  Bind DataSeries to chart
	        //
	        _self.Series = _self.svg.selectAll(".Series")
	            .data(_self.DataSeries)
	            .enter().append("g")
	            .attr("clip-path", "url(#clip-" + _self.guid + ")")
	            .attr("class", "Series");
	        //
	        //  Draw path from Series Data Points
	        //
	        _self.path = _self.Series.append("path")
	            .attr("class", "area")
	            .attr("d", function (d) {
	            return _self.area(d.Data);
	        })
	            //.style("fill", function (d) { return _self.color(d.Name);} )
	            .style("fill", "green")
	            .style("fill-opacity", .25)
	            .style("stroke", function (d) { return _self.color(d.Name); });
	        //
	        //  Legend 
	        //
	        _self.Legend = _self.svg.selectAll(".Legend")
	            .data(_self.DataSeries)
	            .enter().append("g")
	            .attr("class", "Legend");
	        _self.Legend.append("circle")
	            .attr("r", 4)
	            .style("fill", "green")
	            //.style("fill", function (d) { return _self.color(d.Name);})
	            .style("fill-opacity", .5)
	            .style("stroke", function (d) { return _self.color(d.Name);})
	            .attr("transform", function (d, i) {
	            return "translate(" + (_self.width + 6) + "," + (10 + (i * 20)) + ")";
	        });
	        _self.Legend.append("text")
	            .text(function (d) {
	            return d.Name;
	        })
	            .attr("dx", "0.5em")
	            .attr("dy", "0.25em")
	            .style("text-anchor", "start")
	            .attr("transform", function (d, i) {
	            return "translate(" + (_self.width + 6) + "," + (10 + (i * 20)) + ")";
	        });

	        _self.tick = function (id) {
	            _self.thisTick = new Date();
	            var elapsed = parseInt(_self.thisTick - _self.lastTick);
	            var elapsedTotal = parseInt(_self.lastTick - _self.firstTick);
	            if (elapsed < 900 && elapsedTotal > 0) {
	                _self.lastTick = _self.thisTick;
	                return;
	            }
	            if (id < _self.DataSeries.length - 1 && elapsedTotal > 0) {
	                return;
	            }
	            _self.lastTick = _self.thisTick;
	            //console.log(_self.guid, id, _self.DataSeries[id]);
	            //var DataUpdate = [{ Value: (elapsed - 1000) }, { Value: Math.random() * 10 }, { Value: Math.random() * 10 }, { Value: Math.random() * 10}];



	            //Add new values
	            for (i in _self.DataSeries) {
	                _self.DataSeries[i].Data.push({
	                    Value: _self.chartSeries[_self.DataSeries[i].Name]
	                });
	                //Backfill missing values
	                while (_self.DataSeries[i].Data.length - 1 < _self.Ticks + 3) {
	                    _self.DataSeries[i].Data.unshift({
	                        Value: 0
	                    })
	                }
	            }

	            d3.select("#yName-" + _self.guid).text(_self.yText);
	            d3.select("#xName-" + _self.guid).text(_self.xText);
	            d3.select("#title-" + _self.guid).text(_self.titleText);

	            _self.path.attr("d", function (d) {
	                return _self.area(d.Data);
	            })
	                .attr("transform", null)
	                .transition()
	                .duration(_self.TickDuration)
	                .ease("linear")
	                .attr("transform", "translate(" + _self.xscale(-1) + ",0)")
	                .each("end", function (d, i) {
	                _self.tick(i);
	            });

	            //Remove oldest values
	            for (i in _self.DataSeries) {
	                _self.DataSeries[i].Data.shift();
	            }



	        }
	        _self.firstTick = new Date();
	        _self.lastTick = new Date();
	        _self.start = function () {
	            _self.firstTick = new Date();
	            _self.lastTick = new Date();
	            _self.tick(0);

	        }
	        _self.start();
	    }
	    _self.addSeries = function (SeriesName) {
	        _self.chartSeries[SeriesName] = 0;
	        _self.DataSeries.push({
	            Name: SeriesName,
	            Data: [{
	                Value: 0
	            }]
	        });
	        _self.Init();
	    }
	}

	$("#stateOrders").hide();
	
	var chart2 = new chartRT();
	chart2.xText = "Seconds";
	chart2.yText = "Value";
	chart2.titleText = "Random Even Series";
	chart2.Ticks = 5;
	chart2.TickDuration = 1000;
	chart2.MaxValue = 100;


	chart2.addSeries("Orders")

	var updateData = function() { 
		$.get("getData?state="+selectedState, function(data){
		    for (Name in chart2.chartSeries) {
		        chart2.chartSeries[Name] = data;
		    }
	    });       
		setTimeout(updateData, 50);
		
	};          

	setTimeout(updateData, 1000);
