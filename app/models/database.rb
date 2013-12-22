class Database 
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  many :countries

  many :datasets

end