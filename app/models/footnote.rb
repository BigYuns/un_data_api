class Footnote
  include MongoMapper::Document

  key :number, Integer

  key :text, String

  belongs_to :dataset
end