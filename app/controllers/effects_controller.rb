class EffectsController < ApplicationController
  authorize_resource # CanCan
  
  def index
    @effects = Effect.all
  end

  def show
    @effect = Effect.find(params[:id])
  end

  def new
    @effect = Effect.new
  end

  def create
    @effect = Effect.new(params[:effect])
    if @effect.save
      redirect_to @effect, :notice => "Successfully created effect."
    else
      render :action => 'new'
    end
  end

  def edit
    @effect = Effect.find(params[:id])
  end

  def update
    @effect = Effect.find(params[:id])
    if @effect.update_attributes(params[:effect])
      redirect_to @effect, :notice  => "Successfully updated effect."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @effect = Effect.find(params[:id])
    @effect.destroy
    redirect_to effects_url, :notice => "Successfully destroyed effect."
  end
end
