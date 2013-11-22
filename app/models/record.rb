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

  def serialize_hash
    self.serializable_hash(except: [:id, :country_id, :dataset_id]) 
  end
  
end
