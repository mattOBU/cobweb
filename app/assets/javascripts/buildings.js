var submitFormAndCreateNew = function(url) {
  var buildingForm = $('form#new_building');

  if (buildingForm.length > 0) {
    buildingForm.submit();
  } else {
    window.location = url;
  }
};

jQuery(document).ready(function($) {
  // page setup goes here
});
