class Category
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  key :country_ids, Array
  many :countries, in: :country_ids
end
