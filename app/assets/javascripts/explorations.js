jQuery(document).ready(function($) {
  $(".chosen-select").chosen();

  $(".buildings").ajaxChosen({
    type: 'GET',
    url: '/buildings/search',
    datatype: 'json',
    minTermLength: 5
  }, function(data) {
    var results = [];

    $.each(data, function (i, val) {
        results.push({ value: val.id, text: val.address });
    });
console.log(results);

    return results;
  });
});
