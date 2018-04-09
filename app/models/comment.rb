class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  attr_accessible :comment,:post_id,:parent_id
end
