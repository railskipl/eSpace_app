class AboutUsController < ApplicationController
  before_action :set_about_u, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  def index
    @about_us = AboutU.all
    respond_with(@about_us)
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
    respond_with(@about_u)
  end

  def update
    @about_u.update(about_u_params)
    respond_with(@about_u)
  end

  def destroy
    @about_u.destroy
    respond_with(@about_u)
  end

  private
    def set_about_u
      @about_u = AboutU.find(params[:id])
    end

    def about_u_params
      params.require(:about_u).permit(:content,:photo)
    end
end
