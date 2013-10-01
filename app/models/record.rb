class Record
  include MongoMapper::Document

  key :year, Integer
  validates_presence_of :year

  key :value, Float
  validates_presence_of :value

  key :measurement, String
  validates_presence_of :measurement

  key :gender, String

  belongs_to :category
  validates_presence_of :category

  belongs_to :country
  validates_presence_of :country
end
