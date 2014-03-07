var table = new function() {

  var clear = function() {
    $(".results tr").not(function(){if ($(this).has('th').length){return true}}).remove();
  };

  var construct = function(data) {
    clear();
    var buildings = data.buildings;
    _.each(buildings, function(building) {
      _.each(building.annual, function(yearly) {
        $(".results").append("<tr><td>" + building.name + " " + yearly.year +
                            "</td><td>" + yearly.kWhm2 +
                            "</td><td>" + yearly.kgCO2em2 +
                            "</td><td>" + yearly.kWhocc +
                            "</td><td>" + yearly.kgCO2eocc +
                            "</td></tr>");
      });
    });
  };

  return {
    construct: construct
  }

}();

var graphs = new function() {
  var clear = function() {
    $(".charts").empty();
  }
  var construct = function(data) {
    clear();
    var annual = data.buildings[0].annual[0];
    var energyData = [{year: 2013, energy: "mainsE", kWh: annual.mains}, 
                      {year: 2013, energy: "PVused", kWh: annual.producedUsed},
                      {year: 2013, energy: "PVexported", kWh: -annual.producedExported}];
    // simple horizontal barchart for annual consumption
    var svg = dimple.newSvg(".charts", 590, 200);
    var myChart = new dimple.chart(svg, energyData);
    myChart.setBounds(30, 30, 480, 130)
    myChart.addMeasureAxis("x", "kWh");
    myChart.addCategoryAxis("y", ["year"]);
    myChart.addSeries("energy", dimple.plot.bar);
    myChart.addLegend(100, 10, 380, 20, "right");
    myChart.draw();
  };

  return {
    construct: construct
  }
}();

jQuery(document).ready(function($) {
  $(".chosen-select").chosen();

  $(".buildings").ajaxChosen({
    type: 'GET',
    url: '/buildings/search',
    contentType: 'json',
    minTermLength: 5
  }, function(data) {
    var results = [];

    $.each(data, function (i, val) {
        results.push({ value: val.id, text: val.address });
    });

    return results;
  });

  $(".community-groups").ajaxChosen({
    type: 'GET',
    url: '/community_groups/search.json',
    contentType: 'json',
    minTermLength: 5,
    jsonTermKey: "postcode"
  }, function(data) {
    var results = [];

    $.each(data, function (i, val) {
        results.push({ value: val.id, text: val.identifier });
    });

    return results;
  });

  var dataDisplayOnClick = function(event) {
    event.preventDefault();
    var url = $(this).parents('form:first').attr("action");
    var formData = $(this).parents('form:first').serialize();
    $.ajax({
      type: "POST",
      url: url,
      data: formData,
      success: function(data) {
        table.construct(data);
        graphs.construct(data);
      }
    });
    return false;
  };
  // avoid multiple bind
  $(".filter form input[type=submit]").unbind("click", dataDisplayOnClick);
  $(".filter form input[type=submit]").bind("click", dataDisplayOnClick);
});
