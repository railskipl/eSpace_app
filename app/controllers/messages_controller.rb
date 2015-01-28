class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => []
  before_action :set_message, only: [:show]
  respond_to :html, :xml, :json, :js

  def index
     @message = Message.new
     @messages_sender = Message.get_message(current_user.id, params[:recv_id])
     @messages_receiver = Message.get_message(params[:recv_id], current_user.id)
     @total_message = @messages_sender + @messages_receiver
     @total_messages =  @total_message.sort_by { |k| k["id"] }
  end


  #make all messages mark as read.
  def is_read_all
    message = Message.select(:id,:sender_id,:is_read).where("recipient_id = ? AND is_read =?",current_user.id,false).uniq!
    messages_receiver = Message.select(:id,:sender_id,:is_read).where("recipient_id = ?",current_user.id).uniq!.last.sender_id rescue nil
    messages_sender = Message.select(:id,:sender_id,:recipient_id,:is_read).where("sender_id = ?",current_user.id).uniq!.last.recipient_id rescue nil

     message.each do |r|
       if r.is_read == false
        r.update_column('is_read',true)
       end
     end
      unless messages_receiver.nil?
        redirect_to :controller =>'messages',:action=>"index",:recv_id =>messages_receiver
      else
        redirect_to :controller =>'messages',:action=>"index",:recv_id =>messages_sender
      end
  end


  def new
    @message = Message.new
    respond_with(@message)
  end

  def create

    @post = Post.find_by_id(params[:message][:post_id])
    user = User.find_by_email(params[:message][:recipient_id])
    if params["reply"] == "reply"
      Message.create(:body => params[:message][:body],:sender_id => current_user.id, :recipient_id => params[:recipient_id].to_i, :message_id =>params[:message_id].to_i ,:post_id=>params[:post_id].to_i )
      redirect_to :back
    else
      if user.nil?
        redirect_to new_message_url ,:notice => "Please enter recipient"
      else
         Message.create(:body => params[:message][:body], :recipient_id => user.id, :sender_id => current_user.id, :post_id => params[:post_id])
         redirect_to messages_path
      end
    end
  end

  def sent_messages
    @sent_messages = current_user.sent_messages.order("created_at desc") rescue nil
    @sent_messages =  @sent_messages.reject {|i| i.is_deleted_by_sender == true }
  end

  def compose_message
    @user = User.find(params[:user_id])
    @message = Message.new
    respond_with(@message)
  end

  def sent_to
    @message = Message.new(message_params)
    if @message.save
      respond_with(@message, location: compose_message_messages_path)
    end
  end

  #method used for autorefresh message count div &
  #show current updated msg count for curr user.
  def refresh_part

    if params[:restream].nil?
      @msg = current_user.check_message
      render layout: false
    else
       @msg = current_user.check_message

       respond_to do |format|
        format.js
       end
    end

  end

  #method used for autorefresh chat message div &
  #show current updated chat msg.
  def refresh_message

    if params[:restream].nil?
       @messages_sender = Message.where("sender_id = ? AND recipient_id = ?",current_user.id,params[:recv_id])
       @messages_receiver = Message.where("sender_id = ? AND recipient_id = ?",params[:recv_id],current_user.id)
       @total_message = @messages_sender + @messages_receiver
       @total_messages =  @total_message.sort_by { |k| k["id"] }

       unless @messages_sender.empty?
        @@ms ||= @messages_sender.last.id
       end

       unless @messages_receiver.empty?
        @@mr = @messages_receiver.last.id
       end

       render layout: false

    else

      @messages_sender = Message.where("sender_id = ? AND recipient_id = ? AND id >?",current_user.id,params[:recv_id], @@ms)
      @messages_receiver = Message.where("sender_id = ? AND recipient_id = ? AND id >?",params[:recv_id],current_user.id, @@mr)
      @total_message = @messages_sender + @messages_receiver
      @total_messages =  @total_message.sort_by { |k| k["id"] }

      unless @messages_sender.empty?
        @@ms = @messages_sender.last.id
      end

      unless @messages_receiver.empty?
        @@mr = @messages_receiver.last.id
      end

      respond_to do |format|
        format.js
      end

    end
  end

  def check_message
    @messages_receiver = Message.select(:id,:sender_id,:is_read).where("recipient_id = ?",current_user.id).uniq!.last.sender_id rescue nil

    respond_to do |format|
        format.js
    end
  end

  def user_message
     @check_user = current_user.recipient_messages.select(:sender_id).uniq
     @user_messages_sender = current_user.recipient_messages.select(:sender_id).uniq
     @user_messages_receiver = current_user.sent_messages.select(:recipient_id).uniq

     respond_to do |format|
        format.js
      end
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body, :is_deleted_by_recipient, :is_deleted_by_sender, :is_read, :is_trashed_by_recipient, :subject,:sender_id,:recipient_id,:message_id,:post_id)
    end
end
