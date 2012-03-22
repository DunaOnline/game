# encoding: utf-8
class Aplikace
  include ApplicationHelper

  def self.prihlaseni_povoleno?
    Global.vrat('login', 1)
  end

  def self.zakladani_hracu_povoleno?
    Global.vrat('signup', 1)
  end

#  def self.wkhtmltopdf_path_to_bin
#    #TODO casem optimalizovat pro vsechny os
#    #a = ''
#    #if ENV["RAILS_ENV"] == 'production'
#    #  a = "#{Rails.root}/wkhtmltopdf_bin/linux/wkhtmltopdf-amd64"
#    #else
#      a = "#{Rails.root}/wkhtmltopdf_bin/linux/wkhtmltopdf-i386"
#    #end
#    return a
#  end
#
#  def self.cesta_pro_pdf(filename)
#    Rails.root.join('pdfs', "#{filename}.pdf")
#  end
  
  def self.zamkni_hru
    if Aplikace.prihlaseni_povoleno?
      Global.prepni('login', 1, false)
    end
    Aplikace.odhlas_hrace
  end
  
  def self.odemkni_hru
    unless Aplikace.prihlaseni_povoleno?
      Global.prepni('login', 1, true)
    end
  end

  def self.odhlas_hrace
    sessions = Session.all
    sessions.each do |session|
      user = Marshal.load(ActiveSupport::Base64.decode64(session.data))["user_id"]
      if user
        unless User.find(user).admin?
          session.delete
        end
      else
        session.delete
      end
    end
  end
  
end