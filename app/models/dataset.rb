class Dataset
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  key :country_ids, Array
  many :countries, in: :country_ids

  many :records

  def serialize_hash
    self.serializable_hash(except: [:id, :country_ids, :organization_id]) 
  end
  
end
