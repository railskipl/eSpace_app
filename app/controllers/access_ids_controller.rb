class AccessIdsController < ApplicationController
  before_filter :authenticate_user!, :except => []
  
  before_action :set_access, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json


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
	  @access_id.save
	  redirect_to access_ids_path
	end

	def update
	  @access_id.update(access_id_params)
	  redirect_to access_ids_path
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

end
