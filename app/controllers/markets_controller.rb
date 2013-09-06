class MarketsController < ApplicationController
  # GET /markets
  # GET /markets.json
  def index
    #@markets = []
    #@markets << Market.material.cizi(current_user.id).created_desc.price_desc.last unless Market.material.cizi(current_user.id).created_desc.price_desc.last.nil?
    #@markets << Market.melanz.cizi(current_user.id).created_desc.price_desc.last unless Market.melanz.cizi(current_user.id).created_desc.price_desc.last.nil?
    #@markets << Market.populacia.cizi(current_user.id).created_desc.price_desc.last unless Market.populacia.cizi(current_user.id).created_desc.price_desc.last.nil?
    #@markets << Market.expy.cizi(current_user.id).created_desc.price_desc.last unless Market.expy.cizi(current_user.id).created_desc.price_desc.last.nil?
    #@markets << Market.vyrobky.cizi(current_user.id).created_desc.price_desc.last unless Market.vyrobky.cizi(current_user.id).created_desc.price_desc.last.nil?
    #Market.zobraz_trh(current_user).each do |market|
    #@markets << market
    #end
	  @markets = Market.zobraz_trh(current_user)


    @user = current_user
    @market = Market.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @markets }
    end

  end

  # GET /markets/1
  # GET /markets/1.json
  def show
    @market = Market.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @market }
    end
  end

  # GET /markets/new
  # GET /markets/new.json
  def new
    @market = Market.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @market }
    end
  end

  # GET /markets/1/edit
  def edit
    @market = Market.find(params[:id])
  end

  # POST /markets
  # POST /markets.json
  def create
    @market = Market.new(params[:market])

    #domovske_leno = current_user.domovske_leno.resource


    respond_to do |format|
      if @market.sell_goods(current_user) && @market.save

        @market.seller(current_user.id)
        flash[:notice] = 'Ponuka bola uspesne vytvorena'
        format.html { redirect_to action: "index" }
        format.json { render json: @markets, status: :created, location: @market }
      else

        flash[:error] = 'Ponuka nebola vytvorena prosim skuste znova'
        format.html { redirect_to action: "index" }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end

    end
  end

  # PUT /markets/1
  # PUT /markets/1.json
  def update
    @market = Market.find(params[:id])
    opica = (params[:market])
    respond_to do |format|
      #if
      if @market.update_attributes(params[:market])
        #format.html { redirect_to 'index', notice: 'Market was successfully updated.' }
        #format.json { head :no_content }
        format.html { redirect_to markets_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
      #end
    end
  end

  # DELETE /markets/1
  # DELETE /markets/1.json
  def destroy
    @market = Market.find(params[:id])
    if @market.destroy
      current_user.goods_to_buyer(@market.area, @market.amount * 0.7)
    end

    respond_to do |format|
      format.html { redirect_to markets_url, :notice => "Ponuka bola stiahnuta" }
      format.js { render :layout => false }
      format.json { head :no_content }
    end
  end

  def my_offers
    @markets = Market.trh.my_offers(current_user)
  end

  def zlevnit
    @market = Market.find(params[:market])

    if @market.discount
      flash[:notice] = 'Zbozi bylo zlevneno'
      redirect_to :action => 'my_offers'
    else
      flash[:notice] = 'Zbozi nelze zlevnit'
      redirect_to :action => 'my_offers'
    end

  end

  def zdrazet
    @market = Market.find(params[:market])

    if @market.expensive
      flash[:notice] = 'Zbozi bylo zdrazeno'
      redirect_to :action => 'my_offers'
    else
      flash[:notice] = 'Zbozi nelze zdrazit'
      redirect_to :action => 'my_offers'
    end
  end

  def buy
    amount = (params[:q])
    @market = Market.find(params[:market])
		if @market.area.to_i > 0
			if current_user.miesto_v_tovarni?(amount)
				if @market.buy_goods(amount, current_user)
					flash[:notice] = 'Zbozi bylo nakoupeno'
					redirect_to :action => 'index'
				else
		      flash[:error] = 'Chyba skuste nakoupit este jednou'
		      redirect_to :action => 'index'
				end
			else
				flash[:error] = 'Nedostatok miesta'
				redirect_to :action => 'index'
			end
		else

				if @market.buy_goods(amount, current_user)
					flash[:notice] = 'Zbozi bylo nakoupeno'
					redirect_to :action => 'index'
				else
					flash[:error] = 'Chyba skuste nakoupit este jednou'
					redirect_to :action => 'index'
				end

		end

  end
end
