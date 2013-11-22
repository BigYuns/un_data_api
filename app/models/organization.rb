class Organization
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  many :datasets

  key :country_ids, Array
  many :countries, in: :country_ids

  def serialize_hash
    self.serializable_hash(except: [:id, :country_ids]) 
  end

end
