var table = new function() {

  var clear = function() {
    $(".results tr").not(function(){if ($(this).has('th').length){return true}}).remove();
  };

  var construct = function(data) {
    clear();
    var buildings = data.buildings;
    for (var i = 0; i < buildings.length; i++) {
      var building = buildings[i];
      $(".results").append("<tr><td>" + building.name +
                           "</td><td>" + building.kWhm2 +
                           "</td><td>" + building.kgCO2em2 +
                           "</td><td>" + building.kWhocc +
                           "</td><td>" + building.kgCO2eocc +
                           "</td></tr>");
    }
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
      }
    });
    return false;
  };
  // avoid multiple bind
  $(".filter form input[type=submit]").unbind("click", dataDisplayOnClick);
  $(".filter form input[type=submit]").bind("click", dataDisplayOnClick);
});
