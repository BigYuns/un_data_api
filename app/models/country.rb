class Country
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  key :organization_ids, Array
  many :organizations, in: :organization_ids

  key :dataset_ids, Array
  many :datasets, in: :dataset_ids

  many :records

  def serializable_hash(options = {})
    super({ except: [:id, :dataset_ids, :organization_ids] }.merge(options)) 
  end

end
