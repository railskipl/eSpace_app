class AdminsController < ApplicationController
   def index
    @adminusers = User.where("admin =?",false).order('created_at DESC').page(params[:page]).per_page(10) rescue nil
    @post = Post.all
    respond_to do |format|
        format.html
        format.xls
        format.pdf do
           render :pdf => "users_report"
        end
      end
	end
end
