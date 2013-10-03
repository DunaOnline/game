# encoding: utf-8
class SessionsController < ApplicationController

  before_filter :login_required, :except => [:new, :create]

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      if Aplikace.prihlaseni_povoleno? || user.admin?
        session[:user_id] = user.id
        #redirect_to_target_or_default current_user, :notice => "Logged in successfully."
        redirect_to zobraz_eod_path, :notice => " Je čas úřadovat! Milosti vítejte ve hře."
      else
        redirect_to root_url, :alert => "Přihlašování dočasně zakázáno."
      end
    else
#      flash.now[:alert] = "Invalid login or password."
      redirect_to root_url, :alert => "Nesprávná kombinace jména a hesla"
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_url, :notice => "Opustil jste správu svého dominia, brzy se vraťte milosti."
  end
end
