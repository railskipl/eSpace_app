class CommentsController < ApplicationController
   before_filter :authenticate_user!, :except => [:index]
   before_action :set_comment, only: [:show, :edit, :update, :destroy]

    def index
       
      @comments = Comment.includes(:user).where(:post_id => params[:post_id]).paginate(:per_page => 6, :page => params[:page])

      respond_to do |format|
        format.html { render :layout => false}
        format.js
      end

    end

    def books
      @comments = Comment.includes(:user).where(:post_id => params[:post_id]).paginate(:per_page => 4, :page => params[:page])

      respond_to do |format|
        format.html { render :layout => false}
        format.js
      end
      
    end

    
    def show
     @posts = Post.where("user_id != ?",current_user.id)
     @user = User.find_by_id(current_user)
     redirect_to :back
    end

    def create
      
      @post = Post.find(params[:post_id])
      @comment = @post.comments.new(comment_params) 
      @comment.save! 
      redirect_to :back
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy

      redirect_to :back
    end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:name, :comments,:post_id,:rating,:user_id)
    end
end
