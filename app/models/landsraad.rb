# encoding: utf-8
class Landsraad

  POMER_POSLANCE_NA_HRACE = 40

  def self.zapis_operaci(content, kind = "L")
    Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now).save
  end

  def self.zapis_hlasu_imp(user, content)
    Operation.new(:kind => "L", :user_id => user, :content => content, :date => Date.today, :time => Time.now).save
    Operation.new(:kind => "I", :user_id => user, :content => content, :date => Date.today, :time => Time.now).save
  end


  def self.pocet_poslancu
    hracu = User.count
    pocet = (hracu / Landsraad::POMER_POSLANCE_NA_HRACE) * 20
    pocet = 20 if pocet < 20
    return pocet
  end

  def self.rozpustit
    User.update_all(:landsraad => false)
    User.poslanci.each { |u|
      u.update_attribute(:landsraad, false)
      u.zapis_operaci('Landsraad byl rozpuštěn, už nejsem senátorem.')
    }
    Vote.delete_all(:typ => 'imperator')
    Imperium.zapis_operaci('Landsraad byl rozpuštěn.')
  end

end