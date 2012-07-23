# encoding: utf-8
class LawsController < ApplicationController
  authorize_resource # CanCan
  
  # GET /laws
  # GET /laws.json
  def index
    if params[:zakony] == 'vsechny'
      @laws = Law.seradit
    elsif params[:zakony] == 'zarazene'
      @laws = Law.zarazene.seradit
    elsif params[:zakony] == 'projednavane'
      @laws = Law.projednavane.seradit
    elsif params[:zakony] == 'schvalene'
      @laws = Law.schvalene.seradit
    elsif params[:zakony] == 'zamitnute'
      @laws = Law.zamitnute.seradit
    elsif params[:zakony] == 'podepsane'
      @laws = Law.podepsane.seradit
    else
      @laws = Law.podepsane.seradit
    end
    
    if params[:zakony]
      @title = params[:zakony].capitalize + ' zakony'
    else
      @title = 'Podepsane zakony'
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @laws }
    end
  end

  # GET /laws/1
  # GET /laws/1.json
  def show
    @law = Law.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @law }
    end
  end

  # GET /laws/new
  # GET /laws/new.json
  def new
    @law = Law.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @law }
    end
  end

  # GET /laws/1/edit
  def edit
    @law = Law.find(params[:id])
  end

  # POST /laws
  # POST /laws.json
  def create
    puts "\\\\\\\\\\\\\\\\\\ delam create"
    @law = Law.new(params[:law])
    
    @law.label = Law.create_label
    @law.position = Law.create_position
    
    @law.state = Law::STATE[0]
    @law.submitter = current_user.id

    respond_to do |format|
      if @law.save
        format.html { redirect_to @law, notice: 'Law was successfully created.' }
        format.json { render json: @law, status: :created, location: @law }
      else
        format.html { render action: "new" }
        format.json { render json: @law.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /laws/1
  # PUT /laws/1.json
  def update
    @law = Law.find(params[:id])

    respond_to do |format|
      if @law.update_attributes(params[:law])
        format.html { redirect_to @law, notice: 'Law was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laws/1
  # DELETE /laws/1.json
  def destroy
    @law = Law.find(params[:id])
    @law.destroy

    respond_to do |format|
      format.html { redirect_to laws_url }
      format.json { head :ok }
    end
  end
  
  def hlasuj
    
  end
end
