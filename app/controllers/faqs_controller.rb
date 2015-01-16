class FaqsController < ApplicationController
  before_filter :authenticate_user!, :except => [:frequently_asked_question]
  before_filter :correct_user, :only => [:index, :show, :destroy,:create, :edit,:update,:new]
  before_action :set_faq, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  layout :custom_layout

  def index
    @faqs = Faq.all
    respond_with(@faqs)
  end

  def show
    respond_with(@faq)
  end

  def new
    @faq = Faq.new
    1.times do
       @faq.faq_questions.build
     end
    respond_with(@faq)
  end

  def edit
  end

  def create
    @faq = Faq.new(faq_params)
    @faq.save
     redirect_to faqs_path
  end

  def update
    @faq.update(faq_params)
    redirect_to faqs_path
  end

  def destroy
    @faq.destroy
    respond_with(@faq)
  end

  def frequently_asked_question
    if params[:search].present?
      search_condition = "%" + params[:search] + "%"
      @faqs = Faq.faq_search(search_condition)
    else
      @faqs = Faq.includes(:faq_questions)
    end
  end

  private
    def set_faq
      @faq = Faq.find(params[:id])
    end

    def faq_params
      params.require(:faq).permit(:question, :answer,:title, faq_questions_attributes: [:id,:question,:answer,:faq_id,:_destroy])
    end

    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
      redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
    end


    def custom_layout
      case action_name
      when "frequently_asked_question"
        "application"
      else
        "admin"
      end
    end
end
