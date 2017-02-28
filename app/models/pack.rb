class Pack
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String, default: ""
  field :description,       :type => String, default: ""
  field :price,             :type => Float, default: 0
  field :product_id,        :type => String, default: ""

  has_many :tips
  has_many :user_packs, dependent: :destroy

  def info_by_json
    {
      id: self.id.to_s,
      product_id:self.product_id.nil? ? "" : self.product_id,
      name: self.name.nil? ? '' : self.name,
      description: self.description.nil? ? '' : self.description,
      price: self.price}
  end
end
