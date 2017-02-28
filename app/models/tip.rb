class Tip
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :photo, PhotoUploader

  # validates :category, presence: true, uniqueness: true, :unless => :verified?

  # validates :category_id, presence: true

  field :title,             :type => String, default: ""
  field :description,       :type => String, default: ""
  field :content,           :type => String, default: ""
  field :photo,         		:type => String

  has_and_belongs_to_many :categories
  belongs_to :pack

  has_many :favourites, dependent: :destroy
  has_many :states, dependent: :destroy
  # self.per_page = 10

  def category_name
    if self.categories.count > 0
      self.categories.map{|c| c.name}.join(",")
    else
      ""
    end
  end

  def pack_name
    self.pack.present? ? self.pack.name : ""
  end

  def photo_url
    if self.photo.url.nil?
  		""
  	else
      if Rails.env.production?
        self.photo.url
      else
    		ENV['host_url'] + self.photo.url.gsub("#{Rails.root.to_s}/public/tip/", "/tip/")
      end
  	end
  end

  def info_by_json(user)
    f_ids = user.favourites.where(favourite:true).map{|f| f.tip.id.to_s}
    r_ids = user.states.where(read: true).map{|s| s.tip_id.to_s}
    {id: self.id.to_s,
      favourited: f_ids.include?(self.id.to_s),
      read: r_ids.include?(self.id.to_s),
      title: self.title.nil? ? "" : self.title,
      # content: self.content.nil? ? "" : self.content,
      description: self.description.nil? ? "" : self.description,
      photo: self.photo_url,
      category:category_name,
      pack:pack_name}
  end

end
