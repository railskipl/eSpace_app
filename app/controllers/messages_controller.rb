class MessagesController < ApplicationController
   before_filter :authenticate_user!, :except => []
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json, :js
  
  def index
   @message = Message.new
   @messages_sender = Message.where("sender_id = ? AND recipient_id = ?",current_user.id,params[:recv_id])
   @messages_receiver = Message.where("sender_id = ? AND recipient_id = ?",params[:recv_id],current_user.id)
   @total_message = @messages_sender + @messages_receiver
   @total_messages =  @total_message.sort_by { |k| k["id"] }
   @check_user = current_user.recipient_messages.order("id Desc").select(:sender_id).uniq
   @user_messages_sender = current_user.recipient_messages.order("id Desc").select(:sender_id).uniq
   @user_messages_receiver = current_user.sent_messages.order("id Desc").select(:recipient_id).uniq
     
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

  def show

    # @message = Message.new
    @message = Message.find(params[:id])
 
    @original_msg =  @message.message
    @message2 = Message.maximum(:id)
    if @original_msg.nil?
      @msgs = Message.where("post_id = ?",@message.post_id)
    else
      @msgs = Message.where("post_id = ? OR id = ? and message_id = ?",@original_msg.id,@message2,@message.id)
    end

    if @message.sender == current_user
      respond_with(@message)
    else
      if @message.is_deleted_by_recipient == true 
         redirect_to messages_url
      else
        Message.update(@message.id, :is_read => true)  
        respond_with(@message)
      end
    end
end

  def new
    @message = Message.new
    respond_with(@message)
  end

  def edit
  end

  def create
    
    @post = Post.find_by_id(params[:message][:post_id])


    user = User.find_by_email(params[:message][:recipient_id])
       if params["reply"] == "reply"
        @message = Message.new(message_params)
        Message.create(:body => params[:message][:body],:sender_id => current_user.id, :recipient_id => params[:recipient_id].to_i, :message_id =>params[:message_id].to_i ,:post_id=>params[:post_id].to_i )

        redirect_to :back
        else
          if user.nil?
          redirect_to new_message_url ,:notice => "Please enter recipient"
          else
            @message = Message.new(:body => params[:message][:body], :recipient_id => user.id, :sender_id => current_user.id, :post_id => params[:post_id].to_i)
             if @message.save
             redirect_to messages_path
           end
          end
        end  
  end

  def update
    @message.update(message_params)
    respond_with(@message)
  end

  def destroy
    @message.destroy
    redirect_to :controller =>'messages',:action=>"index",:recv_id =>params[:recv_id]
  end

  def trash
    @message = Message.find(params[:id])
    if @message.is_trashed_by_recipient == true
      @message.is_trashed_by_recipient = false
      @message.save
      redirect_to trash_messages_messages_url
    else
      @message.is_trashed_by_recipient = true
      @message.save
      redirect_to messages_url
    end
  end

    def destroy_recipient
    @message = Message.find(params[:id])
    if @message.is_deleted_by_recipient == false
      @message.is_deleted_by_recipient = true
      @message.save
    end
    respond_to do |format|
      format.html { redirect_to trash_messages_messages_url }
      format.json { head :no_content }
    end
  end


  def destroy_sender
    @message =  Message.find(params[:id])
    if @message.is_deleted_by_sender== false
      @message.is_deleted_by_sender = true
      @message.save
    end
    # @message.destroy
    respond_to do |format|
      format.html { redirect_to sent_messages_messages_url }
      format.json { head :no_content }
    end
  end


  def trash_messages
    @messages = current_user.recipient_messages
    # if @messages == nil
    @messages = @messages.reject {|i| i.is_deleted_by_recipient == true || i.is_trashed_by_recipient == false }
    # end
    # @messages = @messages.paginate(page: params[:page], per_page: 10)
  end
 
  def sent_messages
    @sent_messages = current_user.sent_messages.order("created_at desc") rescue nil
    # if @sent_messages == nil
    @sent_messages =  @sent_messages.reject {|i| i.is_deleted_by_sender == true }
    # end
    # @sent_messages = @sent_messages.paginate(page: params[:page], per_page: 10)
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

  def move_all_to_trash_recipient
   message =  Message.where(:id => params[:message_ids])
   message.each do |r|
    if r.is_trashed_by_recipient == true
      r.is_trashed_by_recipient = false
      r.save
    else
      r.is_trashed_by_recipient = true
      r.save
    end
   end
   redirect_to(:back)
   end


  def delete_all_by_sender
   message =  Message.where(:id => params[:message_ids])
   message.each do |r|
      r.is_deleted_by_sender = true
      r.save
    end
   redirect_to sent_messages_messages_url
  end 

  #method user for reply message
  def reply
     @messagee = Message.find(params[:id])
     @message = Message.new
     @messages_sender = Message.where("sender_id = ? AND recipient_id = ?",current_user.id,params[:recv_id])
     @messages_receiver = Message.where("sender_id = ? AND recipient_id = ?",params[:recv_id],current_user.id)
     @total_message = @messages_sender + @messages_receiver
     @total_messages =  @total_message.sort_by { |k| k["id"] }
     @user_messages = current_user.recipient_messages.select(:sender_id).uniq
  end
  
  #method used for autorefresh message count div &
  #show current updated msg count for curr user.
  
  def refresh_part

   @msg = current_user.check_message
   respond_to do |format|
      format.js
    end
  end

  #method used for autorefresh chat message div &
  #show current updated chat msg.
  def refresh_message
    
   @messages_sender = Message.where("sender_id = ? AND recipient_id = ?",current_user.id,params[:recv_id])
   @messages_receiver = Message.where("sender_id = ? AND recipient_id = ?",params[:recv_id],current_user.id)
   @total_message = @messages_sender + @messages_receiver
   @total_messages =  @total_message.sort_by { |k| k["id"] }

  
   respond_to do |format|
      format.js
    end
  end

  def user_message
   @check_user = current_user.recipient_messages.select(:sender_id).uniq
   @user_messages_sender = current_user.recipient_messages.select(:sender_id).uniq
   @user_messages_receiver = current_user.sent_messages.select(:recipient_id).uniq
   @user_messages_sender_last = current_user.recipient_messages.last
   @user_messages_receiver_last = current_user.sent_messages.last
   
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
