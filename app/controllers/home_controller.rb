class HomeController < ApplicationController
 before_filter :authenticate_user!, :except => []
	def index
    @adminusers = User.where("admin =?",false).page(params[:page]).per_page(10)
	end
    
   def contactus
   end
 
    def all_postings
      @posts = Post.where("user_id != ?",current_user.id).order("id desc").page(params[:page]).per_page(10)
    end

    def admin_user
      @adminusers = User.where("admin =?",false).page(params[:page]).per_page(10)
    end
      
    def searching
      q = params[:q].downcase

       @adminusers = User.where(:admin => false).order(:id)
       @adminusers = @adminusers.where("LOWER(name) like ? or LOWER(last_name) like ?", "%#{q}%", "%#{q}%") if q.present?
       

      if params[:created] == 'All'
       
      elsif params[:created] == 'Monthly'
        @adminusers = @adminusers.where(:created_at => Date.today.beginning_of_month..Date.today.end_of_month) if params[:created].present?
      elsif params[:created] == 'Weekly'
        date = Date.today.beginning_of_week
        @adminusers = @adminusers.where(:created_at => Date.today.beginning_of_week..(date + 6.days)) if params[:created].present?
      elsif params[:created] == 'Daily'
        @adminusers = @adminusers.where("Date(created_at) =?" ,Date.today) if params[:created].present?
      end

      respond_to do |format|
      format.html
      format.xls
      format.pdf do
         render :pdf => "users_report"
      end
    end

    end

  
end