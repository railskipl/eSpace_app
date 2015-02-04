class AccessIdsController < ApplicationController
  before_filter :authenticate_user!, except: []
  before_filter :correct_user, :except => []

  before_action :set_access, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json

 layout "admin"
 
	def index
	   @access_ids = AccessId.all
	   respond_with(@access_ids)
	end

	def new
	  @access_id = AccessId.new
	  respond_with(@access_id)
	end

	def edit
	end

	def create
	  @access_id = AccessId.new(access_id_params)
	  
	    respond_to do |format|
	      if @access_id.save
	        format.html { redirect_to access_ids_path, notice: 'College ID was successfully added.' }
	        format.json { render :show, status: :created, location: @access_id }
	      else
	        format.html { render :new }
	        format.json { render json: @access_id.errors, status: :unprocessable_entity  }
	      end
	    end
	end

	def update
	  	respond_to do |format|
		  if @access_id.update(access_id_params)
	        format.html { redirect_to access_ids_path, notice: 'College ID was successfully updated.' }
	        format.json { render :show, status: :ok, location: @access_id }
	      else
	        format.html { render :edit }
	        format.json { render json: @access_id.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
	  @access_id.destroy
	  redirect_to access_ids_path
	end

	private
	    def set_access
	      @access_id = AccessId.find(params[:id])
	    end

	    def access_id_params
	      params.require(:access_id).permit(:email)
	    end

	    def correct_user
      		@user = User.find_by_id_and_admin(current_user.id, true)
      		redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    	end

    	

end
