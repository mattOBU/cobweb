var data = [{group: 2006, kWh: 54},
            {group: 2007, kWh: 43},
            {group: 2008, kWh: 41},
            {group: 2009, kWh: 44},
            {group: 2010, kWh: 35}];

var barWidth = 40;
var width = (barWidth + 10) * data.length;
var height = 200;

var x = d3.scale.linear().domain([0, data.length]).range([0, width]);
var y = d3.scale.linear().domain([0, d3.max(data, function(datum) { return datum.kWh; })]).
  rangeRound([0, height]);


// variables for chart width and height
var w = 20,
    h = 50;

var chart = d3.select(".chart").append("svg")
    .attr("class", "chart")
    .attr("width", w * data.length)
    .attr("height", h);

var x = d3.scale.linear()
    .domain([0, 1])
    .range([0, w]);
     
var y = d3.scale.linear()
    .domain([0, 50])
    .rangeRound([0, h]); //rangeRound is used for antialiasing

// x and y are the lower-left position of the bar
// width is the width of the bar
// height is the height of the bar
// for crisp edges use -.5 (antialiasing)
chart.selectAll("rect")
    .data(data)
  .enter().append("rect")
    .attr("x", function(d, i) { return x(i) - .5; })
    .attr("y", function(d) { return h - y(d.kWh) - .5; })
    .attr("width", w)
    .attr("height", function(d) { return y(d.kWh); } );


// horizontal line for the x-axis
chart.append("line")
     .attr("x1", 0)
     .attr("x2", w * data.length)
     .attr("y1", h - .5)
     .attr("y2", h - .5)
     .style("stroke", "#000");
