class HomeController < ApplicationController
 before_filter :authenticate_user!, :only => [:searching, :all_postings]
 before_filter :correct_user, :only => [:searching, :all_postings]

	def index

	end
    
   def contactus
   end
   
   def about_us
     
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
       @adminusers = @adminusers.where("LOWER(name) like ? or LOWER(last_name) like ? or LOWER(email) like ?", "%#{q}%", "%#{q}%", "%#{q}%") if q.present?

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

    def search_post
      q = params[:q]
       @posts = Post.where("user_id != ?",current_user.id).order("id desc")
       @posts = @posts.where("(created_at) like ? or (created_at) like ?", "%#{q}%", "%#{q}%") if q.present?
       
       @start_date = "#{params['start_date']}"
       @end_date ="#{params['end_date']}"

      if @start_date.blank? || @end_date.blank?
       flash[:error] = "Please Select Date"
       return false
       elsif @start_date > @end_date
       flash[:error] = "Start Date Cannot Be Greater"
      # return false
      else
      @posts = Post.where("date(created_at) >= ? and date(created_at) <= ?",@start_date, @end_date) 
       end
        respond_to do |format|
        format.html
        format.xls
          format.pdf do
          render :pdf => "posts_report"
          end   
        end
    end

    private

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end
    

end