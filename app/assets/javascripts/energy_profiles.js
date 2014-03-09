
jQuery(document).ready(function($) {
  // page setup
  //
  // clicking a data granularity button will show the associated
  //   tab with the proper input fields
  $('#granularities .btn').on('click', function() {
    $(this).find('input').tab('show');
  });

  // by default, select 'yearly' granularity
  if ($('input[name="building_energy_profile[granularity]"]:checked').length == 0) {
    $('#granularities .btn:first').click();
  }
});
