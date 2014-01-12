#encoding: utf-8

module ApplicationHelper
  def format_date_time(cas = Time.now)
    if cas==nil
      ''
    else
      cas.strftime('%d.%m.%Y %H:%M')
    end
  end

  def format_time(cas = Time.now)
    if cas==nil
      ''
    else
      cas.in_time_zone(Time.zone).strftime('%H:%M:%S')
    end
  end

  def format_date(cas = Time.now)
    if cas==nil
      ''
    else
      cas.strftime('%d.%m.%Y')
    end
  end

  def format_mena(castka, mena="", des_cisla=true)
    if des_cisla
      text=number_to_currency(castka, {:unit => mena, :locale => :cs, :format => "%n %u"})
    else
      text=number_to_currency(castka, {:unit => mena, :locale => :cs, :format => "%n %u"}).gsub!('.00', '')
    end
    text
  end

  def img_cancel_s
    # TODO maly obrazek cancel, asi nejaky krizek
    "X"
  end

  def img_solary(title = "Soláry",style = "")
    image_tag("css/solary.png", :alt => title, :title => title, :style => style)
  end

  def img_material(title = "Materiál",style = "")
    image_tag("css/material.png", :alt => title, :title => title, :style => style)
  end

  def img_melanz(title = "Melanž",style = "")
    image_tag("css/melanz.png", :alt => title, :title => title, :style => style)
  end

  def img_populace(title = "Populace",style = "")
    image_tag("css/populace.png", :alt => title, :title => title, :style => style)
  end

  def img_zkusenosti(title = "Zkušenosti",style = "")
    image_tag("css/zkusenosti.png", :alt => title, :title => title, :style => style)
  end

  def img_logo(title = "Emperor - Duna Online")
    image_tag("css/logo.png", :alt => title, :title => title)
  end

  def img_vyrobky(title = "Dilů")
    image_tag("css/vyrobky.png", :alt => title, :title => title)
  end

  def img_kasarna(title = "Celková kapacita kasáren")
    image_tag("css/vybavenost.png", :alt => title, :title => title)
  end

  def img_kosmodrom(title = "Celková kapacita kosmodromů")
    image_tag("css/vybavenostv.png", :alt => title, :title => title)
  end

  def img_po(title = "PO")
    image_tag("css/obrana-pozemni.png", :alt => title, :title => title)
  end

  def img_posta(title = "Pošta")
    image_tag("css/posta.png", :alt => title, :title => title)
  end

  def img_utok(title = "Útok")
    image_tag("css/zautocit.png", :alt => title, :title => title)
  end

  def img_budovy(title = "Postaveno")
    image_tag("css/budovy.png", :alt => title, :title => title)
  end

  def img_fremeni(title = "Fremeni")
    image_tag("css/fremeni.png", :alt => title, :title => title)
  end

  def img_arraken(title = "Arraken")
    image_tag("planety/arrakis_arraken.png", :alt => title, :title => title)
  end

  def img_trash(title = "Odstranit zpr�vu")
	  image_tag('css/delete.png', :alt => title, :title => title)
  end

  def img_pozemni_utok(title = "Pozemni utok")
	  image_tag("css/utok-pozemni.png", :alt => title, :title => title)
  end

  def img_pozemni_obrana(title = "Pozemni obrana")
	  image_tag("css/obrana-pozemni.png", :alt => title, :title => title)
  end

  def img_vesmir_utok(title = "Vesmir utok")
	  image_tag("css/utok-vesmir.png", :alt => title, :title => title)
  end

  def img_vesmir_obrana(title = "Vesmir obrana")
	  image_tag("css/obrana-vesmir.png", :alt => title, :title => title)
  end

  def img_from_model(model)
	  model.img
  end

  def online_users
    @online_users = []
    sessions = Session.order("created_at ASC").all
    sessions.each do |session|
      user = Marshal.load(Base64.decode64(session.data))["user_id"]
      if user
        @online_users << User.find(user)
      end
    end
    @online_users
  end

  # typy budov:
  #  erb - erb
  #  dul - dul 1
  #  kas - kasarna 1
  #  kos - kosmodrom 1
  #  lab - laborator 1
  #  mes - mesto 1
  #  pob - PO 1
  #  tov - tovarna 1
  #  trh - trh 1
  def cesta_budovy(rod, typ)
    cesta = "budovy/"
    case rod
      when "Atreides"
        cesta += "Atreides/"
      when "Corrino"
        cesta += "Corrino/"
      when "Ekaz"
        cesta += "Ekaz/"
      when "Harkonnen"
        cesta += "Harkonnen/"
      when "Moritani"
        cesta += "Moritani/"
      when "Riches"
        cesta += "Riches/"
      when "Vernio"
        cesta += "Vernio/"
      when "Titáni"
        cesta += "Titani/"
      when "Impérium"
        cesta += "Imperium/"
    end
    cesta += typ + ".png"
    #cesta += typ
    #cesta += ".png"
	  cesta
  end
  
  def hodnost_barva(hodnost)
    case hodnost
      when "Admin"
        cesta += "a.admin"
      when "Emperor"
        cesta += "a.emperor"
      when "Arrakis"
        cesta += "a.regent"
      when "Regent"
        cesta += "a.regent"
      when "Leader"
        cesta += "a.leader"
      when "Vezir"
        cesta += "a.regent"
      when "Mentat"
        cesta += "a.mentat"
      when "Army mentat"
        cesta += "a.army_mentat"
      when "Diplomat"
        cesta += "a.diplomat"
      when "Landsraad"
        cesta += "a.poslanec"
      when "General"
        cesta += "a.general"
      else
        cesta += ""
    end
  end
  
  def cesta_rod(rod, typ)
    cesta = "/assets/budovy/"
    case rod
      when "Atreides"
        cesta += "Atreides/"
      when "Corrino"
        cesta += "Corrino/"
      when "Ekaz"
        cesta += "Ekaz/"
      when "Harkonnen"
        cesta += "Harkonnen/"
      when "Moritani"
        cesta += "Moritani/"
      when "Riches"
        cesta += "Riches/"
      when "Vernio"
        cesta += "Vernio/"
      when "Titáni"
        cesta += "Titani/"
      when "Impérium"
        cesta += "Imperium/"
    end
    cesta += typ + ".png"
    #cesta += typ
    #cesta += ".png"

  end

  def obrazek_budovy(rod, typ)
    image_tag(cesta_budovy(rod, typ))
  end

  def cesta_ikona(ikona)
    cesta = "css/" + ikona + ".png"
  end

  def trida_barvy(cislo)
    if cislo > 0.0
      "zelena"
    elsif cislo < 0.0
      "cervena"
    else
      "oranzova"
    end
  end

  def owner?(id)
    if current_user.id == id
      return true
    else
      return false
    end
  end

  def admin_or_owner?(id)
    if (admin? || owner?(id))
      return true
    else
      return false
    end
  end

  def sortable(column, title = nil, desc = false)
	  title ||= column.titleize
	  if desc
		  direction = (column == params[:sort] && params[:direction] == "desc") ? "asc" : "desc"
	  else
		  direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
	  end
	  link_to title, :sort => column, :direction => direction
  end

end
