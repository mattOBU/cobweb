var saveDirtyForms = function() {
  console.log("Looking for dirty forms...");
  $('form.dirty').each(function() {
    //$('#confirm-modal').modal({ backdrop: 'static', keyboard: false});
    console.log("Saving form...");
    $(this).submit();
  });
}

var periodicSave = function(period) {
  setInterval(saveDirtyForms, period);
}

var setDirty = function(el) {
    // set the current form as dirty
    var thisForm = $(el).parents('form')
    console.log("Marking form as dirty");
    thisForm.addClass('dirty');
}

var selectFossilFuelProfileForm = function(el) {
  var selectedForm = $('form input[name="building_energy_profile[profile_type]"][value="' + $(el).val() +'"]').parents('form');
  console.log("Hide all fossil fuel forms");
  $('.fossil_fuel_profiles form').hide();
  console.log("Showing the selected fossil fuel form");
  selectedForm.show();
}
var selectElectricityProfileForm = function(el) {
  var selectedForm = $('form input[name="building_energy_profile[profile_type]"][value="' + $(el).val() +'"]').parents('form');
  console.log("Hide all electricity forms");
  $('.electricity_profiles form').hide();
  console.log("Showing the selected electricity form");
  selectedForm.show();
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

  $('select[name=electricity_profile_type').on('change', function() {
    selectElectricityProfileForm(this);
  });
  $('select[name=fossil_fuel_profile_type').on('change', function() {
    selectFossilFuelProfileForm(this);
  });

  $('form.new_building_energy_profile').on('ajax:success', function(e, data, status, xhr) {
    var thisForm = $('form input[name="building_energy_profile[profile_type]"][value="' + data["profile_type"] + '"]').parents('form');
    console.log("Energy Profile " + data["profile_type"]);
    thisForm.removeClass('dirty');
    console.log("Marking this form as clean");
  }).bind('ajax:error', function(e,xhr,status,error) {
    console.log("Received ajax error");
  });


  // by default, select 'yearly' granularity
  if ($('input[name=granularity]:checked').length == 0) {
    $('#granularities .btn:first').click();
  }

  // select the first electricity profile
  selectElectricityProfileForm($('select[name=electricity_profile_type]')[0]);
  // select the first fossil fuel profile
  selectFossilFuelProfileForm($('select[name=fossil_fuel_profile_type]')[0]);

  // setup periodic save
  periodicSave(2000);
});
