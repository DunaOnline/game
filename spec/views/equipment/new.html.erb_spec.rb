require 'spec_helper'

describe "equipment/new" do
  before(:each) do
    assign(:equipment, stub_model(Equipment,
      :product_id => 1,
      :unit_id => 1,
      :durability => 1
    ).as_new_record)
  end

  it "renders new equipment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", equipment_index_path, "post" do
      assert_select "input#equipment_product_id[name=?]", "equipment[product_id]"
      assert_select "input#equipment_unit_id[name=?]", "equipment[unit_id]"
      assert_select "input#equipment_durability[name=?]", "equipment[durability]"
    end
  end
end
