require 'spec_helper'

describe "ships/show" do
  before(:each) do
    @ship = assign(:ship, stub_model(Ship,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
