class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

    def show
    @posts = Post.where("user_id != ?",current_user.id)
    redirect_to :back
    end

  def create
    
       @post = Post.find(params[:post_id])

       @comment = @post.comments.new(comment_params) 
       @comment.save! 

       redirect_to @post
     
     end

     def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy

      redirect_to :back
  end
     

  #      def rate
  #   @comments = Comment.find(params[:id])
  #   @comments.rate(params[:stars], current_user, params[:dimension])
  #   render :update do |page|
  #     page.replace_html @comments.wrapper_dom_id(params), ratings_for(@comments, params.merge(:wrap => false))
  #     page.visual_effect :highlight, @comments.wrapper_dom_id(params)
  #   end
  # end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:name, :comments,:post_id)
    end
end
