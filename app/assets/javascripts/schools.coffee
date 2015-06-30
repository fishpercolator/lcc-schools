jQuery ->
  if document.getElementById('map')
    $.ajax
      url: $('link[rel="alternate"][type="application/vnd.geo+json"]').attr('href')
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("Couldn't get map JSON - #{textStatus}: #{errorThrown}")
        $('#map').remove()
      success: (data_feature, textStatus, jqXHR) ->
# data_feature can be type: 'Feature' or type: 'FeatureCollection'
        if data_feature.type == 'Feature' and !data_feature.geometry?
          $('#map').remove()
          return

        window.map = new FeatureMap(
          data_feature,
          {
            fitMapToBounds: true
          }
        )
