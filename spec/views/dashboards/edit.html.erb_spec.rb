require 'rails_helper'

RSpec.describe "dashboards/edit", type: :view do
  before(:each) do
    @dashboard = assign(:dashboard, Dashboard.create!(
      :rdd_attribute => "MyString",
      :rdd_value => 1
    ))
  end

  it "renders the edit dashboard form" do
    render

    assert_select "form[action=?][method=?]", dashboard_path(@dashboard), "post" do

      assert_select "input[name=?]", "dashboard[rdd_attribute]"

      assert_select "input[name=?]", "dashboard[rdd_value]"
    end
  end
end
