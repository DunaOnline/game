class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json


  def index
	  @recipient_array = User.all.map &:nick
	  case params[:type]
		  when 'Dorucena'
			  @messages = Message.order('messages.created_at DESC').includes(:conversations).where('conversations.recipient' => current_user, 'conversations.deleted_by' => [nil,"S"])
		  when 'Odoslana'
			  @messages = Message.order('messages.created_at DESC').includes(:conversations).where('conversations.sender' => current_user, 'conversations.deleted_by' => [nil,"R"])
			else
				@messages = Message.includes(:conversations).where('conversations.recipient' => current_user, 'conversations.deleted_by' => [nil,"S"] )
	  end

  end





  # GET /messages/1
  # GET /messages/1.json
  # TODO "procist"
  #def show
  #  @postum = Message.find(params[:id])
  #  Message.procist(@postum)
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @postum }
  #  end
  #end

  # GET /messages/new
  # GET /messages/new.json
  def new

	  @recipient_array = User.all.map &:nick
	  @message = Message.new



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end
  def reply
	  @old_msg = Message.find(params[:id])
	  @recipient_array = User.all.map &:nick
	  @message = Message.new



	  respond_to do |format|
		  format.html # new.html.erb
		  format.json { render json: @message }
	  end
  end


  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @recipient_array = User.all.map &:nick

    respond_to do |format|
      if @message.save
	      Message.posliPostu(current_user,@message.recipients,@message)
        format.html { redirect_to messages_url(:type => "Dorucena"), :notice => "Posta odoslana"}
        format.json { render json: @message }
	      #format.js
      else
        format.html { redirect_to new_message_url, :alert => "Prosim vyplnte chybajuce udaje"  }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        #format.js
      end
    end
  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    postum = Message.find(params[:id])
    postum = postum.conversations.first
		odoslana = postum.sender == current_user.nick
    postum.vymaz(current_user.id,odoslana)

    respond_to do |format|
      format.html { redirect_to messages_url(:type => "Dorucena"), :notice =>"Posta bola vymazana"}
      format.js   { render :layout => false }
      format.json { head :no_content }
    end
  end
end
