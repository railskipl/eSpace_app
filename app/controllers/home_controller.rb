class HomeController < ApplicationController
 before_filter :authenticate_user!, :only => [:searching, :all_postings]
 before_filter :correct_user, :only => [:searching, :all_postings]

 layout :custom_layout

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
      @adminusers = User.page(params[:page]).per_page(10)
    end

      
    def searching

       q = params[:q].downcase

       @adminusers = User.where("admin =?",false).order('created_at DESC')
       @adminusers = @adminusers.where("LOWER(name) like ? or LOWER(last_name) like ? or LOWER(email) like ?", "%#{q}%", "%#{q}%", "%#{q}%") if q.present?
 
      @start_date = "#{params['start_date']}"
      @end_date ="#{params['end_date']}"

      if @start_date > @end_date 
        flash[:error] = "Start Date Cannot Be Greater"
        @adminusers = []
        return false
      else
          @adminusers = @adminusers.where("date(created_at) >= ? and date(created_at) <= ? ",@start_date, @end_date) if @start_date.present? && @end_date.present?
      end

         @adminusers= @adminusers.page(params[:page]).per_page(50)


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

      def custom_layout
        case action_name
         when "index"
          "home"
         else
          "application"
       end
      end
    

end