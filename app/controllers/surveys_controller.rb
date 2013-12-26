# encoding: utf-8
class SurveysController < ApplicationController
	def index
		@surveys = Survey.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @surveys }
		end
	end

	# GET /products/1
	# GET /products/1.json
	def show
		@survey = Survey.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @survey }
		end
	end

	# GET /products/new
	# GET /products/new.json
	def new
		@survey = Survey.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @survey }
		end
	end

	# GET /products/1/edit
	def edit
		@survey = Survey.find(params[:id])
	end

	# POST /products
	# POST /products.json
	def create
		@survey = Survey.new(params[:survey])

		respond_to do |format|
			if @survey.save
				format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
				format.json { render json: @survey, status: :created, location: @survey }
			else
				format.html { render action: "new" }
				format.json { render json: @survey.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /products/1
	# PUT /products/1.json
	def update
		@survey = Survey.find(params[:id])

		respond_to do |format|
			if @survey.update_attributes(params[:survey])
				format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @survey.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /products/1
	# DELETE /products/1.json
	def destroy
		@product = Product.find(params[:id])
		@product.destroy

		respond_to do |format|
			format.html { redirect_to products_url }
			format.json { head :no_content }
		end
	end
end
