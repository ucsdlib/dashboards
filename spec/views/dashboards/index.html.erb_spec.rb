require 'rails_helper'

RSpec.describe "dashboards/index", type: :view do
  before(:each) do
    assign(:dashboards, [
      Dashboard.create(rdd_attribute: "collections", rdd_value: 1),
      Dashboard.create(rdd_attribute: "files", rdd_value: 6)
    ])
  end

  it "renders a list of dashboards" do
    render
  end
end
