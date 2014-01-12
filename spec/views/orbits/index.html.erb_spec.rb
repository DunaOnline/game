require 'spec_helper'

describe "orbits/index" do
  before(:each) do
    assign(:orbits, [
      stub_model(Orbit,
        :planet_id => 1,
        :ship_id => 2,
        :number => 3
      ),
      stub_model(Orbit,
        :planet_id => 1,
        :ship_id => 2,
        :number => 3
      )
    ])
  end

  it "renders a list of orbits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
