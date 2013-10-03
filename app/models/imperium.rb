# encoding: utf-8
class Imperium

  def self.zapis_operaci(content, kind = "I")
    Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now).save
  end

  def self.volba_imperatora?
    Constant.volba_imperatora
  end

  def self.konec_volby_imperatora
    Constant.konec_volby_imperatora
  end

end