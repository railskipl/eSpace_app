class HomeController < ApplicationController
 before_filter :authenticate_user!, :except => []
	def index
    @adminusers = User.where("admin =?",false).page(params[:page]).per_page(10)
	end
    
   def contactus
   end
 
    def all_postings
      @posts = Post.where("user_id != ?",current_user.id).page(params[:page]).per_page(10)
    end

    def admin_user
    @adminusers = User.where("admin =?",false).page(params[:page]).per_page(10)
    end
      def searching
      q = params[:q]
      @adminusers =User.ransack(name_or_last_name_cont: q).result  
      end

   def customer_daily_report
   @adminusers = User.where("Date(created_at) =?" ,Date.today)
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
         render :pdf => "file_name"
      end
    end
   end

   def customer_weekly_report
    date = Date.today.beginning_of_week
    @adminusers	= User.where(:created_at => Date.today.beginning_of_week..(date + 6.days))
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render :pdf => "file_name"
      end
    end
   end


     def customer_monthly_report
    @adminusers = User.where(:created_at => Date.today.beginning_of_month..Date.today.end_of_month)
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render :pdf => "file_name"
      end
    end
   end
end