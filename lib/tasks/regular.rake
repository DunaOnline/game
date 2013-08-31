# encoding: utf-8
namespace :pick do
  desc "Pick a random user as the winner"
  task :winner => :environment do
    puts "Winner: #{pick(User).username}"
  end

  desc "Pick a random planet as the prize"
  task :prize => :environment do
    puts "Prize: #{pick(Planet).name}"
  end

  desc "Pick a random prize and winner"
  task :all => [:prize, :winner]

  def pick(model_class)
    model_class.find(:first, :order => 'RANDOM()')
  end
end

namespace :prepocet do
  desc "Kompletni prepocet"
  task :all => :environment do
    Prepocet.kompletni_prepocet
  end
end