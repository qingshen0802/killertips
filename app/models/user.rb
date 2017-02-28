class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,                type: String, default: ""

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :device_token,        type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  acts_as_token_authenticatable
  field :authentication_token,      :type => String

  has_many :favourites, dependent: :destroy
  has_many :states, dependent: :destroy
  has_many :user_packs, dependent: :destroy

  def self.find_by_token(token)
    User.where(:authentication_token=>token).first
  end

  def info_by_json
    user = self
    user_info={
      id:user.id.to_s,
      name:user.name == nil ? "" : user.name,
      email:user.email,
      token:user.authentication_token,
    }
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64(32)
    end while User.exists?(column => self[column])
  end

  def read_tips(page=1,per_page=15)
    ids = self.states.where(read: true).map{|s| s.tip_id}
    Tip.where({id:{'$in': ids}}).paginate(page:page,per_page:per_page)
  end

  def unread_tips(page=1, per_page=15)
    read_tip_ids = self.states.where(read: true).map{|s| s.tip_id}
    Tip.where(:id.nin=> read_tip_ids).paginate(page: page, per_page: per_page)
  end

  def purchased_packs(page=1)
    packs = []
    self.user_packs.paginate(page: page).each do |up|
      packs << up.pack.info_by_json unless up.pack.nil?
    end
    packs
  end

  def unpurchased_packs(page=1)
    user_pack_ids = self.user_packs.map{|up| up.pack.id.to_s}
    Pack.where(:id.nin => user_pack_ids).paginate(page: page).map{|pp| pp.info_by_json}
  end

  def purchased_tip_ids
    pack_tip_ids = self.user_packs.map{|p| p.tips.map{|t| t.id.to_s}}
    pack_tip_ids.flatten(1).uniq
    # tip_dis = Tip.all.map{|t| t.pack.present? ? nil : t.id.to_s}
  end

  def purchased_tips
    # Tip.find(self.purchased_tip_ids)
    # Tip.where(id: { '$in': self.purchased_tip_ids })
    Tip.any_of({id: { '$in': self.purchased_tip_ids }}, {:pack_id=>nil})
  end

  def unpurchased_tips
    u_t_ids = Tip.where(:id.ne => purchased_tip_ids).map{|t| t.id.to_s}
    Tip.find(u_t_ids)
  end

  def password_as_asteric
    "*****"
  end

end
