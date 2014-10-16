class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json, :js
  
  def index
    @messages = current_user.recipient_messages

    # @messages = @messages.reject {|i| (i.message_id.nil?)} 
     
    if @messages == 0
     @messages = @messages.delete_if {|i| (i.is_deleted_by_recipient == true || i.is_trashed_by_recipient == true)}
    end
    # @messages = @messages.paginate(page: params[:page], per_page: 10)
    respond_with(@messages)
  end

  def show
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

    @msg = Message.new(message_params)
    user = User.find_by_email(params[:message][:recipient_id])
       if params["reply"] == "reply"

        @message = Message.new(message_params)
        Message.create(:subject => @message.subject , :body => @message.body,:sender_id => current_user.id, :recipient_id => params[:recipient_id].to_i, :message_id =>params[:message_id].to_i ,:post_id=>params[:post_id].to_i )
        redirect_to messages_url
        else
          if user.nil?
          redirect_to new_message_url ,:notice => "Please enter recipient"
          else
            @message = Message.create(:subject => @msg.subject, :body => @msg.body, :recipient_id => user.id, :sender_id => current_user.id)
              @message.post_id = @message.id
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
    respond_with(@message)
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


 def reply
 
  @messagee = Message.find(params[:id])
   
   @message = Message.new

 end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body, :is_deleted_by_recipient, :is_deleted_by_sender, :is_read, :is_trashed_by_recipient, :subject,:sender_id,:recipient_id,:message_id)
    end
end
