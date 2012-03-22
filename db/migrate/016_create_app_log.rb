class CreateAppLog < ActiveRecord::Migration
  def self.up
    create_table :app_logy do |t|
      t.column :cas, :datetime, :null => false
      t.column :login, :string, :null => true, :default => nil, :limit => 50
      t.column :login_id, :integer, :null => true, :default => nil
      t.column :controller, :string, :null => false
      t.column :action, :string, :null => false
      t.column :action_id, :integer, :null => true, :default => nil
      t.column :session, :text, :null => true, :default => nil
      t.column :params, :text, :null => true, :default => nil
      t.column :referer, :text, :null => true, :default => nil
      t.column :duration, :integer, :null => true, :default => nil
    end
  end

  def self.down
    drop_table :app_logy
  end
end
