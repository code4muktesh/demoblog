class Tag < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :post_count,:user_id
  has_and_belongs_to_many :posts
  validates :name, :uniqueness => {:scope => :name}

  validates_length_of :name, :minimum => 1, :maximum => 20

end
