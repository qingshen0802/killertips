class Term
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  field :terms,             :type => String, default: ""
  
end
