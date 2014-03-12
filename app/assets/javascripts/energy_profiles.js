var saveDirtyForm = function(el) {
  var thisForm = $(el).parents('form');
  var currentProfileType = thisForm.data('profile-type');
  var newProfileType = $(el).val();

  if (currentProfileType != newProfileType) {
    thisForm.data('switch-to', newProfileType);
    if (thisForm.data('dirty')) {
      //$('#confirm-modal').modal({ backdrop: 'static', keyboard: false});
      console.log("Saving form...");
      thisForm.submit();
    }
  }
}

var setDirty = function(el) {
    // set the current form as dirty
    var thisForm = $(el).parents('form')
    var currentProfileType = thisForm.children('select[name="building_energy_profile[profile_type]"]').val();
    console.log("Marking form as dirty");
    thisForm.data('dirty', true);
    thisForm.data('profile-type', currentProfileType);
}

jQuery(document).ready(function($) {
  // page setup
  //
  // clicking a data granularity button will show the associated
  //   tab with the proper input fields
  $('#granularities .btn').on('click', function() {
    $(this).find('input').tab('show');
  });

  // keep track of changes
  $('input[type=text]').on('keypress', function() {
    setDirty(this);
  });

  $('select[name="building_energy_profile[profile_type]"]').on('change', function() {
    saveDirtyForm(this);
  });

  $('form.new_building_energy_profile').on('ajax:success', function(e, data, status, xhr) {
    console.log("Received ajax response");
    console.log("Energy Profile " + data["profile_type"]);
  }).bind('ajax:error', function(e,xhr,status,error) {
    console.log("Received ajax error");
  });


  // by default, select 'yearly' granularity
  if ($('input[name=granularity]:checked').length == 0) {
    $('#granularities .btn:first').click();
  }
});
