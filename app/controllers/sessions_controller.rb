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
        redirect_to eod_path
      else
        redirect_to root_url, :alert => "Prihlasovani docasne zakazano."
      end
    else
#      flash.now[:alert] = "Invalid login or password."
      render :action => 'new', :alert => "Invalid login or password."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You have been logged out."
  end
end
