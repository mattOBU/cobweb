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
});
