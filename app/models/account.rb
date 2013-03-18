class Account < ActiveRecord::Base
  include Preferences
  
  mount_uploader :logo, LogoUploader
  has_many :users, dependent: :destroy
  accepts_nested_attributes_for :users

  has_many :categories, dependent: :destroy
  has_many :layers, through: :categories
  has_many :contexts, dependent: :destroy

  preference :longitude , -1.676239
  preference :latitude  , 48.118434
  preference :zoom      , 4
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates :subdomain, presence: true, uniqueness: true, subdomain: { :reserved => %w(www test) }

  attr_accessible :name, :subdomain, :users_attributes, :logo, :default

end
