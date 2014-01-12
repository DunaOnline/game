require 'spec_helper'

describe "orbits/new" do
  before(:each) do
    assign(:orbit, stub_model(Orbit,
      :planet_id => 1,
      :ship_id => 1,
      :number => 1
    ).as_new_record)
  end

  it "renders new orbit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", orbits_path, "post" do
      assert_select "input#orbit_planet_id[name=?]", "orbit[planet_id]"
      assert_select "input#orbit_ship_id[name=?]", "orbit[ship_id]"
      assert_select "input#orbit_number[name=?]", "orbit[number]"
    end
  end
end
