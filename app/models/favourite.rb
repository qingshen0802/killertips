class Favourite
  include Mongoid::Document
  include Mongoid::Timestamps

  field :favourite,              :type => Boolean, default: :false

  belongs_to :tip
  belongs_to :user
  def tip_by_json
    tip = self.tip
    {
      id: tip.id.to_s,
      favourited: self.favourite,
      title: tip.title,
      description: tip.description.nil? ? "" : tip.description,
      photo: tip.photo_url,
      category: tip.category_name,
      pack: tip.pack_name
    }
  end
end
