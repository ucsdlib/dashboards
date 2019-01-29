require 'rails_helper'

RSpec.describe "dashboards/new", type: :view do
  before(:each) do
    assign(:dashboard, Dashboard.new(
      :rdd_attribute => "MyString",
      :rdd_value => 1
    ))
  end

  it "renders new dashboard form" do
    render

    assert_select "form[action=?][method=?]", dashboards_path, "post" do

      assert_select "input[name=?]", "dashboard[rdd_attribute]"

      assert_select "input[name=?]", "dashboard[rdd_value]"
    end
  end
end
