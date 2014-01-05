require 'spec_helper'

describe "equipment/edit" do
  before(:each) do
    @equipment = assign(:equipment, stub_model(Equipment,
      :product_id => 1,
      :unit_id => 1,
      :durability => 1
    ))
  end

  it "renders the edit equipment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", equipment_path(@equipment), "post" do
      assert_select "input#equipment_product_id[name=?]", "equipment[product_id]"
      assert_select "input#equipment_unit_id[name=?]", "equipment[unit_id]"
      assert_select "input#equipment_durability[name=?]", "equipment[durability]"
    end
  end
end
