var showAgeGroups = function() {
  var allRow = $('#all-age-groups');
  var groupRows = $('.age-group');

  var showAllRow = function() {
    groupRows.hide();
    allRow.show();
  }

  var showGroupRows = function() {
    groupRows.show();
    allRow.hide();
  }

  if ($("input[name='building_group[age_groups]']:checked").val() == 1) {
    showGroupRows();
  } else {
    showAllRow();
  }

};

jQuery(document).ready(function($) {
  // page setup
  //
  // clicking on a 'sector' button will show the associated
  // tab with the categories
  $('#categories .btn').on('click', function() {
    $(this).find('input').tab('show');
  });

  // by default, select 'whole' sector
  if($('input[name="building_group[category]"]:checked').length == 0) {
    $('#categories .btn:first').click();
  }

  // checking 'group can be broken down by age group' should show the age groups
  showAgeGroups();

  $("input[name='building_group[age_groups]']").on('change', showAgeGroups);
});
