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

  def self.odvolej_imperatora
    User.imperator.each { |i|
      i.update_attribute(:emperor, false)
      i.zapis_operaci('Byl jsem odvolán z pozice Imperátora.')
    } if User.imperator

    User.regenti.each {|r|
      r.update_attribute(:regent, false)
      r.zapis_operaci('Byl jsem odvolán z pozice Regenta.')
    }

    User.veziri.each {|v|
      v.update_attribute(:vezir, false)
      v.zapis_operaci('Byl jsem odvolán z pozice Vezíra.')
    }

    User.dvorane.each {|c|
      c.update_attribute(:court, false)
      c.zapis_operaci('Byl jsem odvolán z pozice Dvořana.')
    }

    User.spravce_arrakis.each { |a|
      a.update_attribute(:arrakis, false)
      a.zapis_operaci('Byl jsem odvolán z pozice Správce Arrakis.')
    } if User.spravce_arrakis

    Global.prepni('konec_volby_imperatora', 2, 3.days.from_now)
    Global.prepni('volba_imperatora', 1, true)
  end

end