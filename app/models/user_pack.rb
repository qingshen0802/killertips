class UserPack
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :pack

  validates :user_id, presence: true
  validates :pack_id, presence: true, uniqueness: { scope: :user_id }


  def tips
    pack.present? ? pack.tips  : []
  end
end
