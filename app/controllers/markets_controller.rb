class MarketsController < ApplicationController
  # GET /markets
  # GET /markets.json
  def index

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
    if params[:sent_from] == "H"
      flag, msg = current_user.house.sell_goods_house(@market)
      @market.house_id = current_user.house_id
      @market.user_id = 0

    elsif params[:sent_from] == "MR"
      flag, msg = current_user.subhouse.sell_goods_subhouse(@market)
      @market.subhouse_id= current_user.subhouse_id
      @market.user_id = 0
    else
      flag, msg = current_user.sell_goods(@market)
      @market.user_id= current_user.id
    end

    if flag && @market.save
      redirect_to :back, :notice => 'Ponuka bola uspesne vytvorena'
    else
      redirect_to :back, :alert => 'Ponuka nebola uspesne vytvorena'
    end
    #respond_to do |format|
    #
    # if flag && @market.save
    #
    #   flash[:notice] = 'Ponuka bola uspesne vytvorena'
    #   format.html { redirect_to action: "index" }
    #   format.json { render json: @markets, status: :created, location: @market }
    # else
    #
    #   flash[:error] = msg
    #   format.html { redirect_to action: "index" }
    #   format.json { render json: @market.errors, status: :unprocessable_entity }
    # end
    #
    #end

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
      current_user.goods_to_buyer(@market.area, @market.amount * Constant.stiahnut_zbozi_trh)
      @market.zapis_obchodu(current_user, "Zbozi bylo stahnuto z trhu bylo straceno #{@market.amount * 0.3} ks #{@market.show_area}")
    end

    respond_to do |format|
      format.html { redirect_to markets_url, :notice => "Ponuka bola stiahnuta" }
      format.js { render :layout => false }
      format.json { head :no_content }
    end
  end

  def my_offers
    @markets = Market.trh.my_offers(current_user)

    @markets_mr = Market.trh.my_offers_subhouse(current_user.subhouse)
    @markets_h = Market.trh.my_offers_house(current_user.house)
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
    amount = params[:q]
    @market = Market.find(params[:market])
    who = params[:who]
    msg = ""

    msg, flag = @market.whos_buying(who, current_user, amount.to_f)
    if  flag
      redirect_to :back, :notice => msg
    else
      redirect_to :back, :alert => msg
    end


  end

  #if @market.area.to_i > 0
  # if current_user.miesto_v_tovarni?(amount.to_i)
  #   if flag = @market.buy_goods(amount, current_user)
  #    msg = 'Zbozi bylo nakoupeno'
  #   else
  #    msg = 'Chyba skuste nakoupit este jednou'
  #   end
  # else
  #   msg = 'Nedostatok miesta v tovarne'
  # end
  #else
  # if flag = @market.buy_goods(amount.to_i, current_user)
  #   msg = 'Zbozi bylo nakoupeno'
  # else
  #   msg = 'Chyba skuste nakoupit este jednou'
  # end


end
