App.Layer = Backbone.RelationalModel.extend
  urlRoot: GEOCMS_PREFIX+"/layers"
  idAttribute: "name"
  defaults: 
    leaflet: false
    onMap: false
    opacity: 90
    timelineCounter: 1
    playing: false
    visible: true
    controllingOpacity: false
    controllingDimension: false
    currentTime: false
    model: "layer"
    base: false

  toLeaflet: ( options = {} ) ->
    unless @get "base"
      tileLayer = L.tileLayer.wms(@get("data_source").wms, {
        layers: @get("name"),
        format: 'image/png',
        transparent: true,
        version: @get("data_source").wms_version,
        styles: @get("default_style") || '',
        continuousWorld: true
      })
      tileLayer.setParams(options)
      @set leaflet: tileLayer

  changeOpacity: (opacity) ->
    @set opacity: opacity
    opacity

  removeFromMap: ->
    @set onMap: false
    @trigger('removeFromMap', this)

  addToMap: ->
    options = {}
    if @get("dimensions") && @get("dimensions")[0]
      dim = @get("dimensions")[0].dimension.value
      options = {time: dim}
      @set currentTime: dim
    @toLeaflet(options)
    @set({onMap : true})
    @trigger('addOnMap')

  toggleVisibility: (visible, value) ->
    @get("leaflet").setOpacity(value)
    @set({opacity: value})

  playTimeline: ->
    that = this
    @set({playing: true})
    @player = setInterval (->
      that.checkTime()
    ), 2000

  pauseTimeline:  ->
    clearInterval @player
    @set({playing: false})

  checkTime: (step = 1) ->
    i = @get("timelineCounter")+step
    next = @get("dimensions")[i]
    if next then @showTime(next.dimension.value, i) else @pauseTimeline()
    @trigger("redraw")

  showTime: (currentTime, timelineCounter) ->
    @set timelineCounter: timelineCounter
    @set currentTime: currentTime 
    @get("leaflet").setParams({time: currentTime}).redraw()

  initialize: (opts)->

