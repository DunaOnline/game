class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :web, :string, :default => ' '
    add_column :users, :icq, :string, :default => ' '
    add_column :users, :gtalk, :string, :default => ' '
    add_column :users, :skype, :string, :default => ' '
    add_column :users, :facebook, :string, :default => ' '
    add_column :users, :presentation, :text, :default => ' '
    add_column :users, :active, :boolean, :default => true
    
    User.all.each do |user|
      user.update_attributes!(:web => ' ')
      user.update_attributes!(:icq => ' ')
      user.update_attributes!(:gtalk => ' ')
      user.update_attributes!(:skype => ' ')
      user.update_attributes!(:facebook => ' ')
      user.update_attributes!(:presentation => ' ')
      user.update_attributes!(:active => true)
    end
  end
end
