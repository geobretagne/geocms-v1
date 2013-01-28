class App.Router extends Backbone.Router
  routes:
    "" : "index"
    ":id" : "show"
    ":id/share": "show"

  initialize: ->
    @mapProvider = new App.MapProviders.Leaflet()
    @catalogCollection = new App.CatalogCollection()
    @catalogCollection.fetch()
    @layerCollection = new App.LayerCollection()
    if gon?
      @layerCollection.reset(gon.layers)
    @cartCollection = new App.CartCollection()

  index: ->
    @context = new App.Context()
    @hudView = new App.HudView({
      model : @context
      cartCollection: @cartCollection
      catalogCollection: @catalogCollection
      layerCollection: @layerCollection
      mapProvider: @mapProvider
      router: this
    })
    $("#catalog").toggleClass("active")

  show: (id) ->
    @context = new App.Context({id: id})
    # Could probably be improved
    that = this
    @context.fetch
      success: (model, response) ->
        that.hudView = new App.HudView({
          model: model
          cartCollection: that.cartCollection
          catalogCollection: that.catalogCollection
          layerCollection: that.layerCollection
          mapProvider: that.mapProvider
          router: that
        })
        _.each response.layers, (l) ->
          console.log l
          layer = that.layerCollection.where({id: l.layer.id})
          # car l'opacté est propre à un context
          layer[0].set  
            opacity: l.layer.opacity 
          that.cartCollection.add(layer)
