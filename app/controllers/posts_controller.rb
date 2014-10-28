class PostsController < ApplicationController

  before_filter :authenticate_user!, :except => []
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle]

  # GET /posts
  # GET /posts.json
  def index

    @posts = Post.search_post(params[:search], current_user.id)

 
  end

  def archive
    @posts = Post.where(archive: true, user_id: current_user.id)
  end

  def all_posts

    if request.post? || params[:search]
      
      @posts = Post.search(params[:search], params[:page], current_user.id)
    else
      @posts = Post.where("user_id != ?",current_user.id).page(params[:page]).per_page(10)
    end

  end
  

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = Comment.where(:post_id => @post)
    
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
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

    #raise @posts.inspect
  
  end


# #   def search
# #   q = params[:q]
# #   if q.nil? || q.present? 
# #     @post =Post.ransack(price_sq_ft_or_area_or_address_cont: q).result 
# #   elsif q.nil? || q.empty? 
# #     redirect_to posts_url ,:alert => "Search field cannot be empty"
# #   else
# #   @post =Post.ransack(price_sq_ft_or_area_or_address_cont: q).result 
# #   # @city_photos = CityPhoto.ransack(title_cont: q).result
# # end
# end
  def toggle
    @post.status = !@post.status?
    @post.save!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post status updated.' }
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

      params.require(:post).permit(:area, :price_sq_ft, :pick_up, :drop_off, :price_include_pick_up, :price_include_drop_off, :pick_up_avaibilty_start_date, :pick_up_avaibility_end_date, :drop_off_avaibility_start_date, :drop_off_avaibility_end_date, :status, :additional_comments, :address, :latitude, :longitude, :user_id,:photo)
    end


end
