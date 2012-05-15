class OperationsController < ApplicationController
  authorize_resource # CanCan
  
  def index
    case params[:jake]
    when 'hrac'
      @hrac = current_user
      @operations = @hrac.operations.seradit.page(params[:page])
      @title = "Operace hrace #{@hrac.nick}"
    when 'narod'
      @narod = current_user.house
      @operations = @narod.operations.seradit.page(params[:page])
      @title = "Operace rodu #{@narod.name}"
    when 'imperium'
      #@narod = current_user.house
      @operations = Operation.imperialni.seradit.page(params[:page])
      @title = "Operace Imperia"
    end
  end

  def show
    @operation = current_user.operations.find(params[:id])
  end

  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.new(params[:operation])
    if @operation.save
      redirect_to @operation, :notice => "Successfully created operation."
    else
      render :action => 'new'
    end
  end

  def edit
    @operation = Operation.find(params[:id])
  end

  def update
    @operation = Operation.find(params[:id])
    if @operation.update_attributes(params[:operation])
      redirect_to @operation, :notice  => "Successfully updated operation."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy
    redirect_to operations_url, :notice => "Successfully destroyed operation."
  end
end
