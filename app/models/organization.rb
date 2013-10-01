class Organization
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  many :categories
end
