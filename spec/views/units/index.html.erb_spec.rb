require 'spec_helper'

describe "units/index" do
  before(:each) do
    assign(:units, [
      stub_model(Unit,
        :name => "Name",
        :house_id => 1,
        :description => "MyText",
        :attack => 2,
        :defence => 3,
        :health => 4,
        :equipment => 5,
        :material => 1.5,
        :solar => 6
      ),
      stub_model(Unit,
        :name => "Name",
        :house_id => 1,
        :description => "MyText",
        :attack => 2,
        :defence => 3,
        :health => 4,
        :equipment => 5,
        :material => 1.5,
        :solar => 6
      )
    ])
  end

  it "renders a list of units" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
