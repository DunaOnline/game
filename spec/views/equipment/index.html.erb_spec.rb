require 'spec_helper'

describe "equipment/index" do
  before(:each) do
    assign(:equipment, [
      stub_model(Equipment,
        :product_id => 1,
        :unit_id => 2,
        :durability => 3
      ),
      stub_model(Equipment,
        :product_id => 1,
        :unit_id => 2,
        :durability => 3
      )
    ])
  end

  it "renders a list of equipment" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
