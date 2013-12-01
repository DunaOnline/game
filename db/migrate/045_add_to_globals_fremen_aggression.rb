class AddToGlobalsFremenAggression < ActiveRecord::Migration
  def up
    Global.create(:setting => 'agrese_fremenu', :cislo => 10)
    Global.create(:setting => 'hranice_harvesteru', :cislo => 30)
  end

  def down
    Global.where(:setting => 'agrese_fremenu').delete_all
    Global.where(:setting => 'hranice_harvesteru').delete_all
  end
end
