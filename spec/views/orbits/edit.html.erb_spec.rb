require 'spec_helper'

describe "orbits/edit" do
  before(:each) do
    @orbit = assign(:orbit, stub_model(Orbit,
      :planet_id => 1,
      :ship_id => 1,
      :number => 1
    ))
  end

  it "renders the edit orbit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", orbit_path(@orbit), "post" do
      assert_select "input#orbit_planet_id[name=?]", "orbit[planet_id]"
      assert_select "input#orbit_ship_id[name=?]", "orbit[ship_id]"
      assert_select "input#orbit_number[name=?]", "orbit[number]"
    end
  end
end
