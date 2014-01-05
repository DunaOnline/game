class SquadsController < ApplicationController

		# GET /units
		# GET /units.json
		def index
			@squads = Squad.all

			respond_to do |format|
				format.html # index.html.erb
				format.json { render json: @squads }
			end
		end

		# GET /units/1
		# GET /units/1.json
		def show
			@field = Field.find(params[:id])
			@lena_s_kasarnou = Field.lena_s_kasarnou
			@units = Unit.house_units(current_user.house).all
			@squad = Squad.new


			respond_to do |format|
				format.html # show.html.erb
				format.json { render json: @squad }
			end
		end

		# GET /units/new
		# GET /units/new.json
		def new
			@squad = Squad.new

			respond_to do |format|
				format.html # new.html.erb
				format.json { render json: @squad }
			end
		end

		# GET /units/1/edit
		def edit
			@squad = Squad.find(params[:id])
		end

		# POST /units
		# POST /units.json
		def create
			@squad = Squad.new(params[:squads])

			respond_to do |format|
				if @unit.save
					format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
					format.json { render json: @unit, status: :created, location: @unit }
				else
					format.html { render action: "new" }
					format.json { render json: @unit.errors, status: :unprocessable_entity }
				end
			end
		end

		# PUT /units/1
		# PUT /units/1.json
		def update
			@squad = Squad.find(params[:id])

			respond_to do |format|
				if @unit.update_attributes(params[:unit])
					format.html { redirect_to @squad, notice: 'Unit was successfully updated.' }
					format.json { head :no_content }
				else
					format.html { render action: "edit" }
					format.json { render json: @squad.errors, status: :unprocessable_entity }
				end
			end
		end

		# DELETE /units/1
		# DELETE /units/1.json
		def destroy
			@squad = Squad.find(params[:id])
			@squad.destroy

			respond_to do |format|
				format.html { redirect_to squads_url }
				format.json { head :no_content }
			end
		end


end
