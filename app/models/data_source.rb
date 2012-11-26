class DataSource < ActiveRecord::Base
  has_many :layers
  attr_accessible :csw, :name, :ogc, :wfs, :wms, :rest

  def import
    geoserver = WmsGetcapabilities::Geoserver.new(self.wms)
    geoserver.get_capabilities
    layers = geoserver.layers
    category = Category.receiver.first

    ActiveRecord::Base.transaction do
      layers.each do |l|

        layer = Layer.as_layer(self, category, l)
        if layer.dimension?
          Dimension.create_dimensions(layer, l.dimension_values)
        end
      end
    end
    layers
  end
end
