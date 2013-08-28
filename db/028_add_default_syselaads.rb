# encoding: utf-8
class AddDefaultSyselaads < ActiveRecord::Migration
  def up
    for house in House.playable do
      Syselaad.create(
        :house_id => house.id, 
        :subhouse_id => nil, 
        :kind => 'N', 
        :name => "Syselaad #{house.name}", 
        :description => "Syselaad národu #{house.name}" 
      )
    end
    
    Syselaad.create(
        :house_id => nil, :subhouse_id => nil, :kind => 'I', :name => "Imperiální Syselaad", 
        :description => "Imperiální Syselaad")
    Syselaad.create(
        :house_id => nil, :subhouse_id => nil, :kind => 'L', :name => "Landsraadský Syselaad", 
        :description => "Landsraadský Syselaad")
    Syselaad.create(
        :house_id => nil, :subhouse_id => nil, :kind => 'S', :name => "Systémový Syselaad", 
        :description => "Systémový Syselaad")
    Syselaad.create(
        :house_id => nil, :subhouse_id => nil, :kind => 'E', :name => "Mezinárodní Syselaad", 
        :description => "Mezinárodní Syselaad")
        
    for syselaad in Syselaad.all do
      syselaad.topics << Topic.create(:syselaad_id => syselaad.id, :user_id => 1, :name => 'Úvod', 
          :last_poster_id => 1, :last_post_at => Time.now, )
    end
    for topic in Topic.all do
      topic.posts << Post.create(:topic_id => topic.id, :user_id => 1, :content => 'Vítejte!')
    end
  end
  

  def down
    Syselaad.destroy_all
  end
end
