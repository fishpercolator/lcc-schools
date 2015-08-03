#
# Manage the leaflet map and its geoJSON features.
# Knows how to:
#   * Set up the leaflet.js map
#   * Style schools
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
        #{
          if school.number_of_admissions
            """
              <dt>Number of admissions</dt>
              <dd>#{school.number_of_admissions}</dd>
            """
          else
           ""
        }
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

  nearestCircle = (feature, radiusPropName, options) ->
    coords = feature.geometry.coordinates
    L.circle(
      [coords[1],coords[0]],
      feature.properties[radiusPropName] * MILES_TO_METRES,
      { opacity: 0.3, color: options.color }
    )

  getMarkerForFeature = (feature, latlng) ->
    if feature.properties.own_admission_policy
      L.marker(
        latlng,
        {
          icon: L.icon({
            iconUrl: '/assets/own-admission-policy.png',
            iconRetinaUrl: '/assets/own-admission-policy2x.png',
            iconSize: [25, 41]
          })
        }
      )
    else
      L.marker(latlng)

  draw: ->
    @map = L.map('map', {
      center: OVER_LEEDS,
      zoom: 12,
      scrollWheelZoom: false
    })

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(@map)

    @layersBySchoolCode = {}
    @featureLayer = L.geoJson(
      @data_feature,
      {
        onEachFeature: (feature, layer) =>
          @layersBySchoolCode[feature.properties.code] = layer
          bindPopup(feature, layer)
        pointToLayer: (feature, latlng) => getMarkerForFeature(feature, latlng)
      }
    ).addTo(@map)

    if(homePoint?)
      @homeLayer = L.geoJson(
        homePoint,
        pointToLayer: (feature, latlng) => L.marker(latlng, { icon: new HouseIcon() })
      ).addTo(@map)

    @nearestLayers    = []
    @nonNearestLayers = []

    @data_feature.features = [@data_feature] unless @data_feature.features?

    @nearestLayers.push(nearestCircle(feature, 'nearest', {color: '#22F'})) \
      for feature in @data_feature.features \
      when feature.properties.nearest?

    @nearestGroup = L.featureGroup(@nearestLayers)

    @nonNearestLayers.push(nearestCircle(feature, 'non_nearest', {color: '#F22'})) \
      for feature in @data_feature.features \
      when feature.properties.non_nearest?

    @nonNearestGroup = L.featureGroup(@nonNearestLayers)

    overlays = {
      "Show schools": @featureLayer,
      "Who got in when it was their nearest school?":    @nearestGroup,
      "Who got in when it wasn't their nearest school?": @nonNearestGroup
    }

    L.control.layers(null, overlays).addTo(@map)

    L.control.scale().addTo(@map)

    if @options.fitMapToBounds
      @fitBounds()
