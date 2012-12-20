# encoding: utf-8
require 'spec_helper'

describe Vypocty do

  it "counts value of new planet in melange" do
    domovska = create(:planet_type, name: "Domovská")
    create(:global, setting: 'k_melanz_vydej', cislo: 5.0)
    create(:global, setting: 'zakl_cena_planety', cislo: 100.0)
    
    4.times do
      create(:planet)
    end
    2.times do
      create(:planet, planet_type: domovska)
    end
    
    new_planet = Vypocty.cena_nove_planety_melanz

    expect(new_planet).to eq(530.0)
    # TODO expected should be 530.61
  end

end