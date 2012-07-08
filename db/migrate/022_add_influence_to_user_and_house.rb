class AddInfluenceToUserAndHouse < ActiveRecord::Migration
  def change
    add_column :users, :influence, :decimal
    add_column :houses, :influence, :decimal
  end
end
