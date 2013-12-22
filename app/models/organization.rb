class Organization
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  many :datasets

  key :country_ids, Array
  many :countries, in: :country_ids

  many :databases

  def serializable_hash(options = {})
    super({ except: [:id, :country_ids] }.merge(options))
  end

end
