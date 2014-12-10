class ContactusController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  before_filter :correct_user, :only => [:index, :show, :edit, :new]
	 before_action :set_contactus, only: [:edit, :update, :destroy]
   respond_to :html, :xml, :json
   layout :custom_layout
  def index
    # @contact = Contactus.all
    @contactus = Contactus.where("message IS NULL")
      # raise @contactus.inspect
  end


  def show
    respond_with(@contactus)
  end

  def new
    @contactus = Contactus.new
    
  end

  def edit
    
  end

  def update
   
    @contactus.update(contact_params)
    redirect_to contactus_path
  end
  
  def create
    if signed_in? 
 
    @contactus = Contactus.new(contact_params)
    @contactus.save
    redirect_to contactus_path
    else
    @contactus = Contactus.new(contactus_params)
    @contactus.save
    #ContactusMailer.contactus(@contactus).deliver
    flash[:notice] = "Thank You for Contacting Us."
    redirect_to root_path
    end 
   
  end

  def destroy
      
      @contactus.destroy

      redirect_to :back
     end


  private
    def set_contactus
      @contactus = Contactus.find(params[:id])
    end

    def contactus_params
      params.require(:contactus).permit(:name, :email,:subject,:message)
    end
    def contact_params
      params.require(:contactus).permit(:subject)
    end

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end
          def custom_layout
        case action_name
         when "index"
          "admin"
        when "new"
          "admin"
       when "edit"
          "admin"
       when "new"
          "admin"
         else
          "application"
       end
      end
    
end
