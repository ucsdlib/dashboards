class Dashboard < ApplicationRecord

  validates :rdd_attribute, presence: true
  validates :rdd_value, presence: true
end
