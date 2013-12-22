class Footnote
  include MongoMapper::Document

  key :number, Integer
  validates_presence_of :number

  key :text, String
  validates_presence_of :text

  belongs_to :dataset
end