# encoding: utf-8
class ApplicationController < ActionController::Base
  include ControllerAuthentication
  helper :all # include all helpers, all the time JUST IN VIEWS! NOT CONTROLLERS
  include ApplicationHelper # to use it in controllers
  
  protect_from_forgery

  after_filter :show_session, :save_output_html, :update_akce, :clear_session
  before_filter :log_akce
  before_filter :login_required
  before_filter :admin_required, :only => [:clear_session]

  before_filter :zapis_uzivatele_do_logu
  
  def admin_required  
    unless current_user && current_user.admin?  
      redirect_to '/'  
    end  
  end
  
  def admin_or_owner_required(id)  
    unless current_user.id == id || current_user.admin?  
      redirect_to '/'  
    end  
  end 

  def zapis_uzivatele_do_logu
    string = "\n-----------------------------------------------------\n"
    string += "V #{format_date_time} provadi uzivatel #{current_user.blank? ? "" : current_user.username} (#{request.env['REMOTE_HOST']}) "
    string += "akci kontroleru = #{params[:controller]}::#{params[:action]} "
    string += "s ID=#{params[:id]} " if params[:id]
    string += "akce=#{params[:akce]}" if params[:akce]
    string += "s ID smlouvy=#{params[:id_sml]} " if params[:id_sml]
    string += "pres filtr: #{params[:filtr]}" if params[:filtr]
    string += "\n-----------------------------------------------------\n "
    logger.info(string)
  end

  helper_method :admin? # aby to slo pouzit i ve view
  def admin?
    return false if current_user.blank?
    current_user.admin?
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Vaše milosti, nechápu jak se to mohlo stát, ale přístup Vám byl zamítnut!"
    redirect_to current_user
  end

  def log_akce
    @app_log = AppLog.new
    @app_log.vloz_akci(current_user, session, params, request.env['HTTP_REFERER'])
  end

  def update_akce
    @app_log.updatuj_dobu_trvani
  end

  def save_output_html
    unless self.response.nil?
      @app_log.zapis_html(self.response.body)
    end
  end

  def show_session
    #puts("Login: #{current_user.blank? ? "neprihlasen" : current_user.login}, #{Utility.uprav_datum_a_cas(Time.now)} => #{params[:controller]}::#{params[:action]}")
    #puts("\nSESSION:\n#{session.to_yaml}\n")
  end

  def clear_session(time = 4.hour)
    Session.sweep(time)
  end
  
end
