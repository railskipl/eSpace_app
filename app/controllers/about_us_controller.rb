class AboutUsController < ApplicationController
  before_filter :authenticate_user!, :except => [:about]
  before_filter :correct_user, :only => [:index, :show, :edit, :new]
  before_action :set_about_u, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
   layout :custom_layout
  def index
    @about_us = AboutU.all.order("id desc")
    respond_with(@about_us)
  end

  def about
    @about_us = AboutU.all
  end

  def show
    respond_with(@about_u)
  end

  def new
    @about_u = AboutU.new
    respond_with(@about_u)
  end

  def edit
  end

  def create
    @about_u = AboutU.new(about_u_params)
    @about_u.save
    redirect_to about_us_path
  end

  def update
    @about_u.update(about_u_params)
    redirect_to about_us_path
  end

  def destroy
    @about_u.destroy
     redirect_to about_us_path
  end

  private
    def set_about_u
      @about_u = AboutU.find(params[:id])
    end

    def about_u_params
      params.require(:about_u).permit(:content,:photo,:name)
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
       when "show"
          "admin"
         else
          "application"
       end
      end
end
