class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  attr_accessible :comment_count, :content,:tags, :title,:user_id,:category_id
  validates :content, :title, presence: true
  validates_length_of :title, :minimum => 1, :maximum => 255
  validates_length_of :content, :minimum => 1, :maximum => 5000
  validates :category_id, presence: true
  has_and_belongs_to_many :tags
  has_many :comments
end
