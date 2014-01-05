require 'spec_helper'

describe "equipment/show" do
  before(:each) do
    @equipment = assign(:equipment, stub_model(Equipment,
      :product_id => 1,
      :unit_id => 2,
      :durability => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
