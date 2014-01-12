require 'spec_helper'

describe "ships/edit" do
  before(:each) do
    @ship = assign(:ship, stub_model(Ship,
      :name => "MyString",
      :description => "MyString",
      :equipment => 1,
      :attack => 1,
      :defence => 1,
      :health => 1,
      :population => 1,
      :material => 1.5,
      :solar => 1.5,
      :salary => 1.5
    ))
  end

  it "renders the edit ship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ship_path(@ship), "post" do
      assert_select "input#ship_name[name=?]", "ship[name]"
      assert_select "input#ship_description[name=?]", "ship[description]"
      assert_select "input#ship_equipment[name=?]", "ship[equipment]"
      assert_select "input#ship_attack[name=?]", "ship[attack]"
      assert_select "input#ship_defence[name=?]", "ship[defence]"
      assert_select "input#ship_health[name=?]", "ship[health]"
      assert_select "input#ship_population[name=?]", "ship[population]"
      assert_select "input#ship_material[name=?]", "ship[material]"
      assert_select "input#ship_solar[name=?]", "ship[solar]"
      assert_select "input#ship_salary[name=?]", "ship[salary]"
    end
  end
end
