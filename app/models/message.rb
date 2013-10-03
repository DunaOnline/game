class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :recipients, :user_id, :druh

  has_many :conversations
  belongs_to :user

  validates_presence_of :subject, :body


  def zisti_id_prijemcu(komu)
    user = User.where('nick' => komu).first
    if user
      user.id
    else
      return false
    end
  end

  def procti_spravu(user)
    sprava = self.conversations.where('receiver' => user).first
    sprava.update_attributes(:opened => true) if sprava
  end

  def proctena(user)
    sprava = self.conversations.where('receiver' => user).first
    if sprava
      sprava.opened
    else
      false
    end
  end

  def vymaz(user, odoslana, prijata)
    if odoslana
      recipients = Conversation.where('receiver' => user, 'message_id' => self.id)
      recipients.each do |r|
        if prijata
          r.update_attributes(:deleted_by => "SR")
          r.update_attributes(:opened => true) if r.opened == nil
        else
          if r.deleted_by == "S"
            r.update_attributes(:deleted_by => "SR")
          else
            r.update_attributes(:deleted_by => "R")
          end
        end

      end

    else
      recipients = Conversation.where('receiver' => user, 'message_id' => self.id)
      recipients.each do |r|
        if r.deleted_by == "S"
          r.update_attributes(:deleted_by => "SR")
        else
          r.update_attributes(:deleted_by => "R")
        end
        r.update_attributes(:opened => true) if r.opened == nil
      end
    end
  end


  def posli_postu(komu)
    #self.update_attribute(:user_id, odosielatel.id)
    narod = self.user.house_id
    malorod = self.user.subhouse_id

    case self.druh
      when "M"
        recipients = User.where(:subhouse_id => malorod, :house_id => narod)
      when "G"
        recipients = User.where(:general => true, :house_id => narod)
      when "N"
        recipients = User.where(:house_id => narod)
      when "D"
        recipients = User.where(:house_id => narod, :diplomat => true)
      when "I"
        recipients = User.all
      else
        recipients = []
    end
    recipients.each do |recipient|
      self.vytvor_postu(self.user, recipient.id)
    end
    if komu
      komu.split(",").each do |recipient|
        recipient = recipient.strip
        #user = nil
        user = self.zisti_id_prijemcu(recipient) if recipient != "" && recipient != nil && self.zisti_id_prijemcu(recipient)
        if user
          self.vytvor_postu(self.user, user)
        end
      end
    end

  end

  def vytvor_postu(odosielatel, komu)
    Conversation.new(
        :message_id => self.id,
        :sender => odosielatel.id,
        :receiver => komu
    ).save
  end


end




