var table = new function() {

  var clear = function() {
    $(".results tr").not(function(){if ($(this).has('th').length){return true}}).remove();
  };

  var construct = function(data) {
    clear();
    _.each(data, function(building) {
        $(".results").append("<tr><td>" + building.name + " " + building.year +
                            "</td><td>" + building.kWh_m2 +
                            "</td><td>" + building.kgCO2e_m2 +
                            "</td><td>" + building.kWh_occ +
                            "</td><td>" + building.kgCO2e_occ +
                            "</td></tr>");
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
    /*
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
    */

console.log(data);
    var svg = dimple.newSvg(".charts", 430, 400);
    myChart = new dimple.chart(svg, data.data);
    myChart.setBounds(30, 45, 400, 315)
    myChart.addCategoryAxis("x", [data.time_unit, "building-name"]);
    myChart.addMeasureAxis("y", data.metrics);
    myChart.addSeries("building-name", dimple.plot.bar);
    myChart.addLegend(100, 10, 300, 20, "right");
    myChart.draw();
  };

  return {
    construct: construct
  }
}();

var search = function() {
    var buildings = function () {
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
    }

    var communityGroups = function() {
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
    }

    var buildingGroups = function() {
        $(".building-groups").ajaxChosen({
            type: 'GET',
            url: '/building_groups/search',
            contentType: 'json',
            minTermLength: 5
        }, function(data) {
            var results = [];

            $.each(data, function (i, val) {
                results.push({ value: val.id, text: val.address });
            });

            return results;
        });
    }

    return {
        buildings: buildings,
        communityGroups: communityGroups,
        buildingGroups: buildingGroups
    }
}()

jQuery(document).ready(function($) {
  $(".chosen-select").chosen();

  search.buildings();
  search.communityGroups();
  search.buildingGroups();

  var dataDisplayOnClick = function(event) {
    event.preventDefault();
    var url = $(this).parents('form:first').attr("action");
    var formData = $(this).parents('form:first').serialize();
    $.ajax({
      type: "POST",
      url: url,
      data: formData,
      success: function(data) {
        //$("#query").text(data.query);
        table.construct(data.table);
        graphs.construct(data.graph);
      }
    });
    return false;
  };
  // avoid multiple bind
  $(".filter form input[type=submit]").unbind("click", dataDisplayOnClick);
  $(".filter form input[type=submit]").bind("click", dataDisplayOnClick);
});
