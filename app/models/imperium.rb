# encoding: utf-8
class Imperium
  
  def self.zapis_operaci(content, kind = "I")
    Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now).save
  end
  
end