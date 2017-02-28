class State
  include Mongoid::Document
  include Mongoid::Timestamps

  field :read,              :type => Boolean, default: :false

  belongs_to :tip
  belongs_to :user

  def tip_by_json
    tip = self.tip
    {
      id: tip.id.to_s,
      title: tip.title,
      description: tip.description,
      category: tip.category_name,
      pack: tip.pack_name
    }
  end

end
