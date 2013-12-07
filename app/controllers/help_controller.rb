class HelpController < ApplicationController
  before_filter :login_required,
                :except => [:help, :landsraad, :hodnosti, :suroviny, :planety_a_lena,
                            :budovy, :arrakis, :transport, :presun, :trh, :vyzkum, :velkorody,
                            :komunikace, :sprava]
                            # sem je potreba dopsat a kazdou novou metodu abz bzla videt i bez prihlaseni

  def help
  end

  def landsraad
  end

  def hodnosti
  end
  
  def suroviny
  end

  def planety_a_lena
  end

  def budovy
  end

  def arrakis
  end

  def transport
  end

  def presun
  end

  def trh
  end

  def vyzkum
  end

  def velkorody
  end

  def komunikace
  end

  def sprava
  end

end