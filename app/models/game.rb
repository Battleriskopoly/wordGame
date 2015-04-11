class Game < ActiveRecord::Base
  has_many :entries
  accepts_nested_attributes_for :entries
  has_many :votes
  accepts_nested_attributes_for :votes
end
