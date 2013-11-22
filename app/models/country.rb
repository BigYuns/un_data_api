class Country
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  key :organization_ids, Array
  many :organizations, in: :organization_ids

  key :dataset_ids, Array
  many :datasets, in: :dataset_ids

  many :records

  def serialize_hash
    self.serializable_hash(except: [:id, :dataset_ids, :organization_ids]) 
  end

end
