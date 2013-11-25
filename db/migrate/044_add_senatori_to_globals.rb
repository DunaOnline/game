class AddSenatoriToGlobals < ActiveRecord::Migration
  def change
    Global.create(:setting => 'pocet_senatoru', :cislo => 20)
  end
end
