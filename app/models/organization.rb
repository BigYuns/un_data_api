class Organization
  include MongoMapper::Document

  key :name, String
  validates_presence_of :name

  key :full_name, String
  validates_presence_of :full_name

  many :datasets

  key :country_ids, Array
  many :countries, in: :country_ids

  many :databases

  def serializable_hash(options = {})
    super({ except: [:id, :country_ids] }.merge(options))
  end

end
