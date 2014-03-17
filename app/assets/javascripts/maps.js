var CobwebMap = {
  setup: function() {
    var map = L.map('map').setView([51.505, -0.09], 14);
    var bwUrl = 'http://{s}.www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png';
    var bwAttrib = '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';

    // draw map tiles
    L.tileLayer(bwUrl, {
      attribution: bwAttrib,
      maxZoom: 18,
    }).addTo(map);


    // place markers
    $('tr').each(function() {
      if ($(this).data('latitude') && $(this).data('longitude')) {
        L.marker([$(this).data('latitude'), $(this).data('longitude')]).addTo(map);
      }
    });

  }
};

jQuery(document).ready(function($) {
  if ($('#map').length > 0) {
    CobwebMap.setup();
  }
});
