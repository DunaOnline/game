class SquadsController < ApplicationController

		# GET /units
		# GET /units.json
		def index
			@squads = Squad.all
			@units = Unit.house_units(current_user.house).all
			@squad = Squad.new
			@user = current_user

			if params[:leno] && params[:leno] != "null"
				@field = Field.find(params[:leno])
			end

			respond_to do |format|
				format.html # index.html.erb
				format.json { render json: @squads }
			end
		end

		# GET /units/1
		# GET /units/1.json
		def show
			@user = current_user
			@field = Field.find(params[:id])
			if @field.user == @user
				@lena_s_kasarnou = Field.lena_s_kasarnou(current_user)
				@units = Unit.house_units(current_user.house).all
				@unit = Unit.new
				@squad = Squad.new


				respond_to do |format|
					format.html # show.html.erb
					format.json { render json: @squad }
				end
			else
				redirect_to :back, :alert => 'No No'
			end
		end

		def move_units
			par = []
			units = Unit.house_units(current_user.house).all.map { |x| x.name }
			source_field = Field.find(params[:leno])
			target_field = Field.find(params[:lena_squad])
			if target_field.kasaren_kapacita
			if source_field.user == current_user && target_field.user == current_user
				units.each do |title|
					par << [([params[title]]), [title]] unless params[title] == nil || params[title] == "0" || params[title] == ""
				end
				if par.any?
					done, msg = source_field.move_units(target_field,par)
						respond_to do |format|
							if done
								format.html { redirect_to squads_path(:leno => source_field.id), notice: msg }
								format.json { render json: msg, status: :created, location: squad_path(source_field.id) }
							else
								format.html { redirect_to :back, alert: msg }
								#format.json { render json: @unit.errors, status: :unprocessable_entity }
							end
						end
				else
					redirect_to :back, :alert => "Nezadali ste jednotky na presun."
				end
			else
				redirect_to :back, :alert => 'Leno vam nepatri.'
			end
			else
				redirect_to :back, :alert => 'Na tom lenu nemate kasaren.'
				end
		end

		# GET /units/new
		# GET /units/new.json
		#def new
		#	@squad = Squad.new
		#
		#	respond_to do |format|
		#		format.html # new.html.erb
		#		format.json { render json: @squad }
		#	end
		#end

		# GET /units/1/edit
		def edit
			@squad = Squad.find(params[:id])
		end

		# POST /units
		# POST /units.json
		def create
			par = []
			jednotky = Unit.house_units(current_user.house).all.map { |x| x.name }
			@field = Field.find(params[:leno])
			if @field.kasaren_kapacita > 0
			jednotky.each do |title|
				par << [([params[title]]), [title]] unless params[title] == ""
			end
			if par.any?
				if params[:commit]
					message, verbovano = @field.verbovanie_jednotiek(par)
					respond_to do |format|
						if verbovano && verbovano != []
							format.html { redirect_to squad_path(@field.id), notice: message }
							format.json { render json: verbovano, status: :created, location: squad_path(@field.id) }
						else
							format.html { redirect_to squad_path(@field.id), alert: message }
							#format.json { render json: @unit.errors, status: :unprocessable_entity }
						end
					end
				elsif params[:zrusit]
					message, prodano = @field.predaj_jednotiek(par)
					respond_to do |format|
						if prodano
							format.html { redirect_to squad_path(@field.id), notice: message }
							format.json { render json: message, status: :created, location: squad_path(@field.id) }
						else
							format.html { redirect_to squad_path(@field), alert: message }
							format.json { render json: message, status: :created, location: squad_path(@field.id) }
						end
					end
				end
			else
				redirect_to :back, :alert => "Zadajte mnozstvo."
			end
			else
			  redirect_to :back, :alert => "Nemate postavenu kasaren."
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
