class UnitsController < ApplicationController
  # GET /units
  # GET /units.json
  def index
	  if current_user.admin
		  @units = Unit.all
		  @squad = Squad.new

		  respond_to do |format|
			  format.html # index.html.erb
			  format.json { render json: @units }
		  end
	  else
		  redirect_to squads_path
	  end
  end

  # GET /units/1
  # GET /units/1.json
  def show
	  if current_user.admin
    @unit = Unit.find(params[:id])
	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @unit }
	    end
	  else
		  redirect_to squads_path
	  end
  end

  # GET /units/new
  # GET /units/new.json
  def new
	  if current_user.admin
		  @unit = Unit.new

		  respond_to do |format|
			  format.html # new.html.erb
			  format.json { render json: @unit }
		  end
	  else
		   redirect_to squads_path
	  end

  end

  # GET /units/1/edit
  def edit
	  if current_user.admin
		  @unit = Unit.find(params[:id])
	  else
		  redirect_to squads_path
	  end
  end

  # POST /units
  # POST /units.json
  def create
	  if current_user.admin
		  @unit = Unit.new(params[:unit])

		  respond_to do |format|
			  if @unit.save
				  format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
				  format.json { render json: @unit, status: :created, location: @unit }
			  else
				  format.html { render action: "new" }
				  format.json { render json: @unit.errors, status: :unprocessable_entity }
			  end
		  end
	  else
		 redirect_to squads_path
	  end

  end

  # PUT /units/1
  # PUT /units/1.json
  def update
	  if current_user.admin

    @unit = Unit.find(params[:id])

    respond_to do |format|
      if @unit.update_attributes(params[:unit])
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end

	  else
		  redirect_to squads_path
		end

  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
	  if current_user.admin
		  @unit = Unit.find(params[:id])
		  @unit.destroy

		  respond_to do |format|
			  format.html { redirect_to units_url }
			  format.json { head :no_content }
		  end
	  else
		  redirect_to squads_path
	  end

  end
end
