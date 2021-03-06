class Record
  include MongoMapper::Document

  key :year, Integer
  validates_presence_of :year

  key :value, Float
  validates_presence_of :value

  key :measurement, String
  validates_presence_of :measurement

  key :gender, String

  belongs_to :dataset
  validates_presence_of :dataset

  belongs_to :country
  validates_presence_of :country

  key :footnote_ids, Array
  many :footnotes, in: :footnote_ids

  key :area_name, String
  validates_presence_of :area_name

  def serializable_hash(options = {})
    super({ except: [:id, :country_id, :dataset_id, :footnote_ids], include: [:footnotes] }.merge(options)) 
  end

end
