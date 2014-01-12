require 'spec_helper'

describe "ships/index" do
  before(:each) do
    assign(:ships, [
      stub_model(Ship,
        :name => "Name",
        :description => "Description",
        :equipment => 1,
        :attack => 2,
        :defence => 3,
        :health => 4,
        :population => 5,
        :material => 1.5,
        :solar => 1.5,
        :salary => 1.5
      ),
      stub_model(Ship,
        :name => "Name",
        :description => "Description",
        :equipment => 1,
        :attack => 2,
        :defence => 3,
        :health => 4,
        :population => 5,
        :material => 1.5,
        :solar => 1.5,
        :salary => 1.5
      )
    ])
  end

  it "renders a list of ships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
