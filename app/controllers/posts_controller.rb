class PostsController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle, :toggled_feature]
  before_filter :authenticate_user!
  before_filter :correct_user, :only => [:toggled_feature]
  before_action :check_user_privilege, only: [:toggle, :edit, :update]

  include PostsHelper
  include BookingsHelper

  # GET /posts
  # GET /posts.json
  def index
    q = params[:search]

    posts = Post.search_post(q, current_user.id)

    @start_date = "#{params['start_date']}"
    @end_date ="#{params['end_date']}"

    posts = posts.result(@start_date,@end_date) if @start_date.present? && @end_date.present?
    @posts = posts.get_post(params[:page])

    respond_to do |format|
      format.html
    end

  end

  def archive
    @posts = Post.get_archive(current_user.id)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    # remaining_area(@post)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to bank_details_path, notice: 'Post is now live. Please enter card details to receive the payment.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity  }
      end
    end
  end

  def overview
      if params[:search]
        @overviews = Post.includes(:user).search_overview(params[:search], params[:page], params[:sort])
        @posts = Post.includes(:user).search(params[:search], params[:page], params[:sort])
      else
        @overviews = Post.includes(:user).order(sort_order).where(" drop_off_avaibility_end_date >= ? and status = ? and archive = ? and area_available >= ?",Date.today, true,false,4)
        @posts = Post.includes(:user).page(params[:page]).per_page(4).order(sort_order).where(" drop_off_avaibility_end_date >= ? and status = ? and archive = ? and area_available >= ?",Date.today, true,false,4)
      end
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.html.erb
      format.xml
    end
  end


  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    respond_to do |format|
      if @post.update(post_params)

        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.archive = true
    @post.save
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post was successfully archived.' }
      format.json { head :no_content }
    end
  end

  def search
    @posts = Post.search(params[:search], params[:page])
  end

  def toggle

    @post.status = !@post.status?
    @post.save!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post status updated.' }
      format.json { head :no_content }
    end

  end

   def toggled_feature

    @post.status = !@post.status?
    @post.save!
     respond_to do |format|
      format.html { redirect_to home_all_postings_path, notice: 'Post status updated.' }
      format.json { head :no_content }
    end
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params[:post][:pick_up_avaibilty_start_date].to_date
      params[:post][:pick_up_avaibility_end_date].to_date
      params[:post][:drop_off_avaibility_start_date].to_date
      params[:post][:drop_off_avaibility_end_date].to_date

      params.require(:post).permit(:area, :price_sq_ft, :pick_up, :drop_off, :price_include_pick_up, :price_include_drop_off, :pick_up_avaibilty_start_date, :pick_up_avaibility_end_date, :drop_off_avaibility_start_date, :drop_off_avaibility_end_date, :status, :additional_comments, :address, :latitude, :longitude, :user_id,:photo,:featured,:street_add,:apt,:city,:state,:zip_code,:area_available)
    end

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end

    def check_user_privilege
      redirect_to posts_path, notice: 'Sorry, you are not allowed to access that page.' unless @post.user_id == current_user.id
    end


    def sort_order
      sort_column + " " + sort_direction
    end

    #Sort PostColumn
    def sort_column
      Post.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
