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
  MILES_TO_METRES = 1609.344

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

  HouseIcon = L.Icon.extend({ options: {
    shadowUrl:       '/assets/House-shadow.png',
    shadowRetinaUrl: '/assets/House-shadow2x.png',
    iconUrl:         '/assets/House.png',
    iconRetinaUrl:   '/assets/House2x.png',
    iconSize:     [30, 30], # size of the icon
    shadowSize:   [45, 25], # size of the icon
    iconAnchor:   [12, 30], # point of the icon which will correspond to marker's location
    shadowAnchor: [12, 26], # point of the icon which will correspond to marker's location
  }})

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

    @homeLayer = L.geoJson(
      homePoint,
      pointToLayer: (feature, latlng) =>
        L.marker(latlng, { icon: new HouseIcon() })
    ).addTo(@map)

    @nearestLayers = []

    nearestCircle = (feature) ->
      L.circle(
        feature.geometry.coordinates.reverse(),
        feature.properties.nearest * MILES_TO_METRES
      )

    @nearestLayers.push(nearestCircle(feature)) \
      for feature in @data_feature.features \
      when feature.properties.nearest?

    @nearestGroup = L.featureGroup(@nearestLayers)


    baseLayers = {
      "OpenStreetMap": osmLayer
    }

    overlays = {
      "Show schools": @featureLayer,
      "Show last year's nearest admissions": @nearestGroup,
      "Show last year's cutoff areas": []
    }

    L.control.layers(baseLayers, overlays).addTo(@map)

    @featureLayer.addTo(@map);

    if @options.fitMapToBounds
      @fitBounds()
