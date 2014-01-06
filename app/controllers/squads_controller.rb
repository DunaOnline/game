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
			if @field.user == current_user
				@lena_s_kasarnou = Field.lena_s_kasarnou
				@units = Unit.house_units(current_user.house).all

				@squad = Squad.new


				respond_to do |format|
					format.html # show.html.erb
					format.json { render json: @squad }
				end
			else
				redirect_to :back, :alert => 'No No'
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
			jednotky.each do |title|
				par << [([params[title]]), [title]] unless params[title] == ""
			end
			if par.any?
				if params[:commit]
					message, verbovano = field.verbovanie_jednotiek(par)

				respond_to do |format|
					if verbovano
						format.html { redirect_to squad_path(@field.id), notice: message }
						format.json { render json: verbovano, status: :created, location: squad_path(@field.id) }
					else
						format.html { redirect_to :back, alert: message }
						#format.json { render json: @unit.errors, status: :unprocessable_entity }
					end
				end
				elsif params[:zrusit]
					message, prodat = field.predaj_produktov(par)
					respond_to do |format|
						if prodat
							format.html { redirect_to production_url(field), notice: message }
							format.json { render json: @production, status: :created, location: @production }
						else
							format.html { redirect_to production_url(field), alert: message }
							format.json { render json: @production, status: :created, location: @production }
						end
					end
				end
			else

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
