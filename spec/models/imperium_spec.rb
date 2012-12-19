require 'spec_helper'

describe Imperium do
  
  it "returns elections are on" do
    global = create(:global, setting: 'volba_imperatora')
    Global.prepni('volba_imperatora', 1, true)
    
    election = Imperium.volba_imperatora?
    expect(election).to eq(true)
  end
  
  it "returns elections are off" do
    global = create(:global, setting: 'volba_imperatora')
    Global.prepni('volba_imperatora', 1, false)
    
    election = Imperium.volba_imperatora?
    expect(election).to eq(false)
  end
  
  it "returns end of elections" do
    global = create(:global, setting: 'konec_volby_imperatora', datum: 2.days.from_now)
    #Global.prepni('volba_imperatora', 1, false)
    
    end_of_election = Imperium.konec_volby_imperatora
    expect(end_of_election).to eq(2.days.from_now.to_date)
  end
  
  it "creates operation for Empire" do
    Imperium.zapis_operaci("Test operation")
    
    test_op = Operation.where(:kind => "I", :content => "Test operation")
    expect(test_op).to_not be_empty 
  end
  
end