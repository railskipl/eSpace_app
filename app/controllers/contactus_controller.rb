class ContactusController < ApplicationController
	 respond_to :html, :xml, :json
def index
    @contactus = Contactus.all
    
  end

  def show
    respond_with(@contactus)
  end

  def new
    @contactus = Contactus.new
    
  end

  
  def create
    @contactus = Contactus.new(contactus_params)
    @contactus.save

    flash[:notice] = "Thank You for Contacting Us." 
    redirect_to root_path
  end



  private
    def set_contactus
      @contactus = Contactus.find(params[:id])
    end

    def contactus_params
      params.require(:contactus).permit(:name, :email,:subject,:message)
    end
end
