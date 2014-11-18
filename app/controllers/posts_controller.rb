class PostsController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!, :except => [:overview]
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle]
  include PostsHelper

  # GET /posts
  # GET /posts.json
  def index
   @posts = Post.search_post(params[:search], current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml
    end
  end

  def archive
    @posts = Post.where(archive: true, user_id: current_user.id)
  end

  def all_posts
    if params[:search]
      @posts = Post.search(params[:search], params[:page], current_user.id).order(sort_column + " " + sort_direction)
    else
      @posts = Post.where("user_id != ?",current_user.id).page(params[:page]).per_page(4).order(sort_column + " " + sort_direction)
    end

  end

  def mutual
      @user_fb_token = current_user.oauth_token
      @users = User.find_by_id(params[:user_id])
      @graph = Koala::Facebook::API.new(@users.oauth_token) 
      @graph1 = Koala::Facebook::API.new(@user_fb_token)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
   
    
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
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def overview

    unless user_signed_in? 

      @overviews = Post.page(params[:page]).order(sort_column + " " + sort_direction)
      if params[:search]
        @posts = Post.search_without_login(params[:search], params[:page]).order(sort_column + " " + sort_direction)
      else
        @posts = Post.page(params[:page]).per_page(4).order(sort_column + " " + sort_direction)
      end

    else

      @overviews = Post.where("user_id != ?",current_user.id).page(params[:page]).order(sort_column + " " + sort_direction)
      if params[:search]
        @posts = Post.search(params[:search], params[:page], current_user.id).order(sort_column + " " + sort_direction)
      else
        @posts = Post.page(params[:page]).per_page(4).order(sort_column + " " + sort_direction)
      end

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
    @post = Post.find(params[:id])
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

      params.require(:post).permit(:area, :price_sq_ft, :pick_up, :drop_off, :price_include_pick_up, :price_include_drop_off, :pick_up_avaibilty_start_date, :pick_up_avaibility_end_date, :drop_off_avaibility_start_date, :drop_off_avaibility_end_date, :status, :additional_comments, :address, :latitude, :longitude, :user_id,:photo,:featured)
    end


    #Sort PostColumn 
    def sort_column
      Post.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
