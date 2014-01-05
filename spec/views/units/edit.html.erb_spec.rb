require 'spec_helper'

describe "units/edit" do
  before(:each) do
    @unit = assign(:unit, stub_model(Unit,
      :name => "MyString",
      :house_id => 1,
      :description => "MyText",
      :attack => 1,
      :defence => 1,
      :health => 1,
      :equipment => 1,
      :material => 1.5,
      :solar => 1
    ))
  end

  it "renders the edit unit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", unit_path(@unit), "post" do
      assert_select "input#unit_name[name=?]", "unit[name]"
      assert_select "input#unit_house_id[name=?]", "unit[house_id]"
      assert_select "textarea#unit_description[name=?]", "unit[description]"
      assert_select "input#unit_attack[name=?]", "unit[attack]"
      assert_select "input#unit_defence[name=?]", "unit[defence]"
      assert_select "input#unit_health[name=?]", "unit[health]"
      assert_select "input#unit_equipment[name=?]", "unit[equipment]"
      assert_select "input#unit_material[name=?]", "unit[material]"
      assert_select "input#unit_solar[name=?]", "unit[solar]"
    end
  end
end
