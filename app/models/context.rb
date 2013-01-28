class Context < ActiveRecord::Base
  acts_as_tenant(:account)
  has_many :contexts_layers, :dependent => :destroy
  has_many :layers, :through => :contexts_layers, :uniq => true

  attr_accessible :maxx, :maxy, :minx, :miny, :name, :zoom, :description, :center_lng, :center_lat, :layer_ids, :uuid, :contexts_layers_attributes
  accepts_nested_attributes_for :contexts_layers
  before_create :generate_uuid
  
  def contexts_layers_attributes=(attrs)
    
    attrs.each do |attr|
      context_layer = contexts_layers.detect{|cl| cl.layer_id == attr["layer_id"]}
      puts context_layer.inspect
      context_layer ||= contexts_layers.build
      context_layer.update_attributes(attr)
    end

  end

  def generate_uuid
    str = self.account.subdomain
    str.gsub!("-", "")
    self.uuid = str+"-"+(0...8).map{65.+(rand(26)).chr.downcase}.join
  end

  def bbox
    [minx, miny, maxx, maxy].join(",")
  end
end
