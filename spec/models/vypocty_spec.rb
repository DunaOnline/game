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

  it "counts value of new planet in solars" do
    domovska = create(:planet_type, name: "Domovská")
    create(:global, setting: 'k_solar_vydej', cislo: 5.0)
    create(:global, setting: 'zakl_cena_planety', cislo: 100.0)

    4.times do
      create(:planet)
    end
    2.times do
      create(:planet, planet_type: domovska)
    end

    new_planet = Vypocty.cena_nove_planety_solary

    expect(new_planet).to eq(53000.0)
    # TODO expected should be 53061.0
  end

  it "counts value of new field in melange" do
    create(:global, setting: 'k_melanz_vydej', cislo: 5.0)
    create(:global, setting: 'zakl_cena_lena', cislo: 100.0)

    planet = create(:planet)
    10.times do
      create(:field, planet: planet)
    end

    new_field = Vypocty.cena_noveho_lena_melanz(planet)

    expect(new_field).to eq(550.0)
    # TODO expected should be 550.0
  end

  it "counts value of new field in solars" do
    create(:global, setting: 'k_solar_vydej', cislo: 5.0)
    create(:global, setting: 'zakl_cena_lena', cislo: 100.0)

    planet = create(:planet)
    10.times do
      create(:field, planet: planet)
    end

    new_field = Vypocty.cena_noveho_lena_solary(planet)

    expect(new_field).to eq(55000.0)
    # TODO expected should be 55000.0
  end

end