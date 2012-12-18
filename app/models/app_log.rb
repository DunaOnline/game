# == Schema Information
#
# Table name: app_logy
#
#  id         :integer          not null, primary key
#  cas        :datetime         not null
#  login      :string(50)
#  login_id   :integer
#  controller :string(255)      not null
#  action     :string(255)      not null
#  action_id  :integer
#  session    :text
#  params     :text
#  referer    :text
#  duration   :integer
#

class AppLog < ActiveRecord::Base
#  require 'zip/zipfilesystem'
  belongs_to :user, :class_name => "User", :foreign_key => "login_id"

  BASE_DIR = "./exporty/html_vystupy/"

  def session()
    return preved_string_na_hash(self[:session])
  end

  def session=(session)
    self[:session] = preved_hash_na_string(session)
  end

  def params()
    return preved_string_na_hash(self[:params])
  end

  def params=(params)
    self[:params] = preved_hash_na_string(params)
  end

  def referer()
    return preved_string_na_hash(self[:referer])
  end

  def referer=(referer)
    return if referer.blank?
    env = Rack::MockRequest.env_for(referer)
    req = Rack::Request.new(env)
    params = req.params
    params["cesta_info"] = req.path_info
    self[:referer] = preved_hash_na_string(params)
  end

  def vloz_akci(user, session, params, referer)
    begin
      self.cas = Time.now
      unless user.blank?
        self.login = user.username
        self.user = user
      end
      self.controller = params[:controller]
      self.action = params[:action]
      self.action_id = params[:id] unless params[:id].blank?
      self.session = session
      self.params = params
      self.referer = referer
      return self.save
    rescue => ex
      logger.info("Zalogovani chyba: #{ex.to_s}")
      return false
    end
  end

  def zapis_html(data)
    begin
      raise "Pozadavek nema id, nepodarilo se jej zapsat do db" if self.id.blank?
      directory = AppLog::BASE_DIR + Date.today.strftime("%Y-%m-%d/")
      Dir.mkdir(directory) unless File.exists?(directory)
      File.open(directory + self.id.to_s + ".html", "w") { |f| f.write(data) }
      return true
    rescue => ex
      logger.info("Chyba pri zapisu vystupniho html: #{ex.to_s}")
      return false
    end
  end

  def updatuj_dobu_trvani
    begin
      self.duration = (Time.now - self.cas)
      return self.save
    rescue => ex
      logger.info("Zalogovani chyba (update casu): #{ex.to_s}")
      return false
    end
  end

  def preved_hash_na_string(hash)
    parametry = Array.new
    hash.each { |key, value|
      next if key == "user_password"
      parametry << "#{key}: #{preved_typy_na_string(value)}"
    }
    return parametry.join("\n")
  end

  def preved_string_na_hash(string)
    parametry = string.split("\n")
    params = Hash.new
    parametry.each { |parametr|
      index = parametr.index(":")
      key = parametr[0 ,index]
      value = parametr[index + 2, parametr.length - 1].sub("\\n", "\n")
      params[key] = value
    }
    return params
  end

  def preved_typy_na_string(hodnota)
    if hodnota.kind_of?(String)
      hodnota =  hodnota = hodnota.nil? ? "" : hodnota.to_s.gsub(/(\r)?\n/, "\\n")
    elsif hodnota.kind_of?(Array)
      hodnota = "[#{hodnota.collect{ |p| preved_typy_na_string(p) }.join(", ")}]"
    elsif hodnota.kind_of?(Hash)
      hsh = Array.new
      hodnota.each{ |k, v| hsh << "#{k} => \"#{preved_typy_na_string(v)}\"" }
      hodnota = "{#{hsh.join(", ")}}"
    end
    return hodnota
  end

  # AppLog.zazipuj(Date.today)
  def self.zazipuj(date = (Date.today - 1))
    date = date.strftime("%Y-%m-%d")
    return unless File.exists?(AppLog::BASE_DIR + date + "/")

    Zip::ZipFile.open(AppLog::BASE_DIR + date + ".zip", Zip::ZipFile::CREATE) { |zipfile|
      zipfile.dir.mkdir(date)
      Dir.glob(AppLog::BASE_DIR + date + "/*").each { |file|
        File.open(file, "r") { |infile|
          soubor_nazev = File.basename(file)
          zipfile.file.open(date + "/" + soubor_nazev, "w") { |f|
            while(radek = infile.gets)
              f.puts radek
            end
          }
        }
        File.delete(file)
      }
    }
    Dir.delete(AppLog::BASE_DIR + date)
  end

  # prevodnik pro generator dat grafu (i pro xls)
  PREVODNIK = {
    "minuta" => Proc.new { |i, j|
      p = "%Y-%m-%d %H:%M"
      p1 = "%Y-%m-%d %H:%i"
      k, pop = vygeneruj_data_klice(p, 1.minute, "%M", i, j)
      [p1, k, pop, "minuty", p]
    },
    "hodina" => Proc.new { |i, j|
      p = "%Y-%m-%d %H"
      k, pop = vygeneruj_data_klice(p, 1.hour, "%H", i, j)
      [p, k, pop, "hodiny", p]
    },
    "den" => Proc.new { |i, j|
      p = "%Y-%m-%d"
      k, pop = vygeneruj_data_klice(p, 1.day, "%d", i, j)
      [p, k, pop, "dny", p]
    },
    "mesic" => Proc.new { |i, j|
      p = "%Y-%m"
      k, pop = vygeneruj_data_klice(p, 1.month, "%m", i, j)
      [p, k, pop, "mesice", p]
    }
  }

  # vygeneruje xls
#  def self.to_xls(worksheet, rozliseni, cas_od, cas_do, akce, kdo, sedi_na_cc)
#    sheet = worksheet.add_sheet("Statistiky akcí", 0)
#    default_format = Rxl::Format.new(Rxl::Format::DEFAULT_OPTIONS)
#    header_format = default_format.merge({:background => {:color => :GRAY_25}, :font => {:bold => true}})
#    option_format = default_format.merge({:font => {:bold => true}})
#    column=0
#    row=1
#    loginy = Hash.new
#    pattern, k, l, m, o = AppLog::PREVODNIK[rozliseni].call(cas_od, cas_do)
#
#    sheet.add_cell(column, row, "zobrazení:", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, rozliseni, Rxl::Cell::TYPE_LABEL, default_format)
#    row+=1
#    sheet.add_cell(column, row, "od (včetně):", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, cas_od.strftime(o), Rxl::Cell::TYPE_LABEL, default_format)
#    row+=1
#    sheet.add_cell(column, row, "do (vyjma):", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, cas_do.strftime(o), Rxl::Cell::TYPE_LABEL, default_format)
#    row+=1
#    sheet.add_cell(column, row, "akce:", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, akce.blank? ? "všechny" : akce, Rxl::Cell::TYPE_LABEL, default_format)
#    row+=1
#    sheet.add_cell(column, row, "uživatel:", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, kdo.blank? ? "všichni" : kdo, Rxl::Cell::TYPE_LABEL, default_format)
#    row+=1
#    sheet.add_cell(column, row, "Pouze pro CC:", Rxl::Cell::TYPE_LABEL, option_format)
#    sheet.add_cell(column+1, row, sedi_na_cc ? "ano" : "ne", Rxl::Cell::TYPE_LABEL, default_format)
#
#    row+=2
#    sheet.add_cell(column, row, "login", Rxl::Cell::TYPE_LABEL, header_format)
#    sheet.add_cell(column+1, row, "počet", Rxl::Cell::TYPE_LABEL, header_format)
#
#    data = graf_data_rozmezi(pattern, cas_od, cas_do, akce, kdo, sedi_na_cc)
#
#    data.each do |ua|
#      loginy[ua.login] = 0 if loginy[ua.login].blank?
#      loginy[ua.login] += ua.pocet.to_i
#    end
#
#    loginy.sort.each do |login, pocet|
#      row+=1
#      sheet.add_cell(column, row, login, Rxl::Cell::TYPE_LABEL, default_format)
#      sheet.add_cell(column+1, row, pocet , Rxl::Cell::TYPE_NUMBER, default_format.merge(:data_format => Rxl::NumberFormat.new(:THOUSANDS_INTEGER)))
#    end
#
#    sheet.change_column(column, {:size => :auto})
#    sheet.change_column(column+1, {:size => :auto})
#
#    return sheet
#  end

#  # generuje data pro graf
#  def self.graf_data(rozliseni = "den", cas_od = Time.local(2010, 10, 1), cas_do = Time.local(2010, 10, 31), akce = nil, kdo = nil, sedi_na_cc = true)
#    g = Graph.new
#    max = 10
#    loginy = Hash.new
#    pattern, klice, popisky, osa_x_popisek, d_pattern = AppLog::PREVODNIK[rozliseni].call(cas_od, cas_do)
#    data = graf_data_rozmezi(pattern, cas_od, cas_do, akce, kdo, sedi_na_cc)
#    data.each do |ua|
#      u = loginy[ua.login]
#      loginy[ua.login] = u = klice.clone if u.blank?
#      u[ua.rozmezi] = ua.pocet.to_i
#      max = ua.pocet.to_i if max < ua.pocet.to_i
#    end
#    barvy = Utility.vygeneruj_barvy(loginy.length)
#    i = barvy.length.to_f / (loginy.length == 0 ? 1.0 : loginy.length.to_f)
#    odstup = -i
#    loginy.sort.each do |login, rozmezi|
#      hodnoty = rozmezi.sort.collect { |x| x[1] }
#      g.set_data(hodnoty)
#      g.line_dot(2, 4, barvy[i += odstup], login, 10)
#    end
#
#    g.set_tool_tip("#key#: #val#<br>#{rozliseni}: #x_label#")
#    g.set_y_max(max - (max % 8) + 8)
#    g.set_x_legend( "Čas (#{osa_x_popisek})", 12, "#164166" )
#    g.set_y_legend( "Operace", 12, "#164166" )
#    g.set_x_labels(popisky)
#    g.set_x_label_style(10, "#164166", 0, popisky.size/16, "#818D9D" )
#    g.set_y_label_steps(8)
#
#    return g
#  end

  def self.vygeneruj_data_klice(pattern, rozsah, popisky_pattern, first, second)
    klice = Hash.new
    popisky = Array.new
    t = first
    while t < second
      klice[t.strftime(pattern)] = 0
      popisky << t.strftime(popisky_pattern)
      t += rozsah
    end
    return klice, popisky
  end


end
