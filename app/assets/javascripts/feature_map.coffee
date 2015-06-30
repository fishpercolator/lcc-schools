#
# Manage the leaflet map and its geoJSON features.
# Knows how to:
#   * Set up the leaflet.js map
#   * Style sites
#   * Style markers
#   * Style popups
#   * Fit to displayed features if requested
#
class @FeatureMap
  OVER_LEEDS      = [53.801277, -1.548567]
  DEFAULT_OPTIONS = {
    fitMapToBounds: true
  }

  constructor: (@data_feature, @options = DEFAULT_OPTIONS) ->
    @draw()

  bindPopup = (feature, layer) ->
    school = feature.properties # for readability in the template
    layer.bindPopup("""
      <h3>
        <a href="/schools/#{school.code}">#{school.name}</a>
      </h3>
      <dl>
        <dt>Number of pupils</dt>
        <dd>#{school.number_of_pupils}</dd>
        <dt>Available places</dt>
        <dd>#{school.available_places}</dd>
        <dt>Number of admissions</dt>
        <dd>#{school.number_of_admissions}</dd>
      </dl>
    """, { minWidth: 200, schoolCode: school.code} )

  fitBounds: (e) =>
    options = { maxZoom: 15 }

    # Cope with race condition causing map freeze. Decorous 50ms grace given
    setTimeout ( =>
      markerBounds = @featureLayer.getBounds()
      @map.fitBounds(markerBounds, options) if markerBounds? and markerBounds.isValid()
    ), 50

  getMap: =>
    @map

  layerBySchoolCode: (schoolCode) -> @layersBySchoolCode[schoolCode]

  draw: ->
    @map = L.map('map', {
      center: OVER_LEEDS,
      zoom: 12,
      scrollWheelZoom: false
    })

    osmLayer = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(@map)

    @layersBySchoolCode = {}
    @featureLayer = L.geoJson(
      @data_feature,
      onEachFeature: (feature, layer) =>
        @layersBySchoolCode[feature.properties.code] = layer
        bindPopup(feature, layer)
    )

    baseLayers = {
      "OpenStreetMap": osmLayer
    }

    overlays = {
      "Show schools": @featureLayer,
      "Show last year's cutoff areas": []

    }

    L.control.layers(baseLayers, overlays).addTo(@map)

#    @markers.addLayer(@featureLayer)
    @featureLayer.addTo(@map);

    if @options.fitMapToBounds
      @fitBounds()
