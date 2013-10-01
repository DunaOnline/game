class PollsController < ApplicationController
  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @polls }
    end
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @poll }
    end
  end

  # GET /polls/new
  # GET /polls/new.json
  def new
    @poll = Poll.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @poll }
    end
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(params[:poll])
    @poll.choice = params[:commit]
    @poll.user_id = current_user.id
    zakon = Law.find(params[:law_id])
    @poll.law_id = zakon.id


    if @poll.save
      Poll.zapis_hlasu(current_user.id, "Poslanec #{current_user.nick} hlasoval pro zakon #{zakon.label} - #{zakon.title} za #{@poll.choice} .")
      flash[:notice] = "Hlas bol prideleny"
      redirect_to landsraad_jednani_path
      #format.html { redirect_to 'landsraad_jednani', notice: 'Law was successfully created.' }
      #format.json { render json: @law, status: :created, location: @law }
    else
      flash[:error] = "Hlas nebol prideleny"
      redirect_to landsraad_jednani_path
    end
    #respond_to do |format|
    #  if @poll.save
    #    format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
    #    format.json { render json: @poll, status: :created, location: @poll }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @poll.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PUT /polls/1
  # PUT /polls/1.json
  def update
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_url }
      format.json { head :ok }
    end
  end
end
