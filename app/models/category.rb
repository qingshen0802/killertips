class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String

  # has_many :tips, dependent: :destroy
  has_and_belongs_to_many  :tips
  def info_by_json
    {id: self.id.to_s, name: self.name}
  end
end
