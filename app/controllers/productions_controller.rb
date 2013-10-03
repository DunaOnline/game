# encoding: utf-8
class ProductionsController < ApplicationController
  # GET /productions
  # GET /productions.json
  def index
    @productions = Production.all
    @products = Product.zakladni
    @fields_factories = current_user.resourcy_s_tovarny
    @production = Production.new


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @productions }
    end
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
    @kapacita = Constant.kapacita_tovaren
    @products = Product.zakladni
    @fields_factories = Field.find_by_id(params[:id])
    if @fields_factories
      if @fields_factories.user == current_user
        @production = Production.new
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @production }
        end
      else
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end

  # GET /productions/new
  # GET /productions/new.json
  #def new
  #  @production = Production.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @production }
  #  end
  #end

  # GET /productions/1/edit
  #def edit
  #  @production = Production.find(params[:id])
  #end

  # POST /productions
  # POST /productions.json
  def create

    vyrobky = Product.all.map { |x| x.title }
    field = Field.find(params[:leno])
    par = []
    vyrobky.each do |title|
      par << [[params[title]], [title]] unless params[title] == ""
    end
    if par.any?
      if params[:commit]
        message, vyrobeno = field.vyroba_vyrobkov(par)

        respond_to do |format|
          if vyrobeno
            format.html { redirect_to production_url(field), notice: 'Vyrobky byli vyrobeny' }
            format.json { render json: @production, status: :created, location: @production }
          else
            format.html { redirect_to production_url(field), alert: message }
            format.json { render json: @production, status: :created, location: @production }
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
      redirect_to production_url(field), alert: "Zadejte prosim pocet vyrobku"
    end
  end

  def presun_vyrobku
    source = Field.find(params[:source_production])
    target = Field.find(params[:target_production])
    vyrobok = Product.find(params[:presunout_co])
    mnozstvo = (params[:amount]).to_i

    if source.drzitel(current_user) && target.drzitel(current_user)
      case str = source.move_products(vyrobok, target, mnozstvo)
        when true
          flash[:notice] = "Vyrobky byli presunuty"
          redirect_to productions_path
        else
          flash[:error] = str
          redirect_to productions_path
      end
    else
      flash[:error] = "Můžeš posílat jen mezi svými lény."
      redirect_to productions_path

    end
  end


  # PUT /productions/1
  # PUT /productions/1.json
  #def update
  #  @production = Production.find(params[:id])
  #
  #  respond_to do |format|
  #    if @production.update_attributes(params[:production])
  #      format.html { redirect_to @production, notice: 'Production was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @production.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /productions/1
  # DELETE /productions/1.json
  #def destroy
  #  @production = Production.find(params[:id])
  #  @production.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to productions_url }
  #    format.json { head :no_content }
  #  end
  #end
end
