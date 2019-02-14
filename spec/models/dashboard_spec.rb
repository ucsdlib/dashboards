require 'rails_helper'

RSpec.describe Dashboard, type: :model do

  it {should validate_presence_of(:rdd_attribute)}
  it {should validate_presence_of(:rdd_value)}
  pending "add some examples to (or delete) #{__FILE__}"
end
