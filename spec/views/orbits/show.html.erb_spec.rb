require 'spec_helper'

describe "orbits/show" do
  before(:each) do
    @orbit = assign(:orbit, stub_model(Orbit,
      :planet_id => 1,
      :ship_id => 2,
      :number => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
