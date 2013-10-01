class Country
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  key :organization_ids, Array
  many :organizations, in: :organization_ids

  key :category_ids, Array
  many :categories, in: :category_ids

end
