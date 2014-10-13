class PostsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle]

  # GET /products
  # GET /products.json
  def index
    @posts = current_user.posts
    # @search = Post.search(@posts)
    # @q = Post.search(params[:q])
    # @post = @q.result.includes(:post)
    # @search.build_condition if @search.conditions.empty?
    # @post = @search.result
      
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @post = Post.new(post_params)
  end

  # GET /products/new
  def new
    @post = Post.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
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

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
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

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search

     if params[:search].nil? || params[:search].present? 
      @post = Post.where("price_sq_ft like ? OR area like ? OR address like ?","%#{params[:search]}%","%#{params[:search]}%","%#{params[:search]}%")
      elsif params[:search].present? || params[:search].nil?
      @post = Post.where("price_sq_ft like ? OR area like ? OR address like ?","%#{params[:search]}%","%#{params[:search]}%","%#{params[:search]}%")

      elsif params[:search].nil? || params[:search].empty?
      redirect_to posts_url ,:alert => "Search field cannot be empty"
      else
      @post = Post.where("price_sq_ft like ? OR area like ? OR address like ?","%#{params[:search]}%","%#{params[:search]}%","%#{params[:search]}%")
    end
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
