#
# Manage the interactions between the map and the table:
#  * Highlight sites in the table when selected on the map
#  * Zoom to sites on the map when clicked in the table
#
class @SchoolHighlighter
  constructor: (@featureMap) ->
    schoolRows().each((index, row) =>
      if @featureMap.layerBySchoolCode($(row).attr('data-school-code'))
        $(row)
          .addClass('map-available')
          .find('a').on('click', (e) =>
            @schoolRowClicked(e)
            e.stopPropagation()
          )
      else
        $(row).addClass('not-on-map')
    )

    @leafletMap = @featureMap.getMap()
    @leafletMap.on('popupopen',  @popupOpened)

  schoolRows = ->
    $('.schools tr.school')

  popupOpened: (e) =>
    @highlightSchoolCode(e.popup.options.schoolCode)

  featureClassList = (layer) ->
    $(layer._container).find('path,.leaflet-marker-icon').get(0).classList

  unhighlight: (layer) ->
    if layer
      switch layer.feature.geometry.type
        when 'Polygon'
          featureClassList(layer).remove('highlight')
        when 'Point'
          layer.setZIndexOffset(0)
          $(layer._icon).removeClass('highlight')

  highlight: (layer) ->
    if layer
      switch layer.feature.geometry.type
        when 'Polygon'
          featureClassList(layer)?.add('highlight')
          layer.bringToFront()
          @leafletMap.fitBounds(layer.getBounds(), {padding: [100,100]})
        when 'Point'
          layer.setZIndexOffset(1000)
          @leafletMap.setView(layer.getLatLng(), 13)
          setTimeout ->
            $(layer._icon).addClass('highlight')
          , 250

  highlightSchoolCode: (schoolCode) ->
    layer = @featureMap.layerBySchoolCode(schoolCode)
    if layer
      @unhighlight(@highlightedLayer)
      schoolRows().removeClass('highlighted')
      @highlightedLayer = layer
      @highlight(layer)
      $("table.schools .school[data-school-code=#{schoolCode}]").addClass('highlighted')

  schoolRowClicked: (e) =>
    $row = $(e.currentTarget)
    @highlightSchoolCode($row.attr('data-school-code'), $row)



