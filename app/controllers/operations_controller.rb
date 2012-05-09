class OperationsController < ApplicationController
  def index
    @operations = Operation.all
  end

  def show
    @operation = Operation.find(params[:id])
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
