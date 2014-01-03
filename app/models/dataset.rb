class Dataset
  include MongoMapper::Document
  
  key :name, String
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  belongs_to :database
  validates_presence_of :database

  key :country_ids, Array
  many :countries, in: :country_ids

  key :topics, Array

  many :records

  many :footnotes 

  def serializable_hash(options = {})
    super({ except: [:id, :country_ids, :organization_id, :database_id, :topics] }.merge(options)) 
  end

end
