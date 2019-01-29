require 'rails_helper'

RSpec.describe "dashboards/index", type: :view do
  before(:each) do
    assign(:dashboards, [
      Dashboard.create!(
        :rdd_attribute => "Rdd Attribute",
        :rdd_value => 2
      ),
      Dashboard.create!(
        :rdd_attribute => "Rdd Attribute",
        :rdd_value => 2
      )
    ])
  end

  it "renders a list of dashboards" do
    render
    assert_select "tr>td", :text => "Rdd Attribute".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
