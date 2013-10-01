class Organization
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  many :categories

  key :country_ids, Array
  many :countries, in: :country_ids
end
