require 'rails_helper'

RSpec.describe "dashboards/show", type: :view do
  before(:each) do
    @dashboard = assign(:dashboard, Dashboard.create!(
      :rdd_attribute => "Rdd Attribute",
      :rdd_value => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Rdd Attribute/)
    expect(rendered).to match(/2/)
  end
end
