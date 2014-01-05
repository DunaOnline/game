require 'spec_helper'

describe "units/show" do
  before(:each) do
    @unit = assign(:unit, stub_model(Unit,
      :name => "Name",
      :house_id => 1,
      :description => "MyText",
      :attack => 2,
      :defence => 3,
      :health => 4,
      :equipment => 5,
      :material => 1.5,
      :solar => 6
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/1.5/)
    rendered.should match(/6/)
  end
end
