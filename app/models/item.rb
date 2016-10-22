class Item < ActiveRecord::Base
  belongs_to :list
	validates :title, :list, presence: true
end
