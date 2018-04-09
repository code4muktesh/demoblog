class Category < ActiveRecord::Base

  attr_accessible :name, :post_count, :slug,:user_id
  belongs_to :user
  has_many :posts
  validates :name, :uniqueness => {:scope => :name}
  validates :slug, :uniqueness => {:scope => :slug}
  validates_length_of :name, :minimum => 1, :maximum => 20
  validates_length_of :slug, :minimum => 1, :maximum => 20
end
