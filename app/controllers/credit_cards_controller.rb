class CreditCardsController < ApplicationController

  before_filter :authenticate_user!, :except => []
  before_action :set_credit_card, only: [:destroy]
  respond_to :html, :xml, :json, :js

  def index
     credit_card = current_user.credit_card

    if credit_card.present?
      @credit_card = credit_card
    else
      redirect_to new_credit_card_path
    end

  end


  def new
    @credit_card = CreditCard.new
  end


  def create

    if params[:stripe_card_token] != nil

      email = params[:credit_card][:email]
      user_id = params[:credit_card][:user_id]


      begin
        customer = Stripe::Customer.create(
          :email => email,
          :card  => params[:stripe_card_token],
          :description => "Customer #{email}"
        )
      rescue Stripe::InvalidRequestError => e
        redirect_to :back, :notice => "Stripe error: #{e.message}"
        return false
      end

CreditCard.create(:email => email, :stripe_customer_id => customer.id, :user_id => user_id)

      redirect_to credit_cards_path

    else
      render :new
      flash[:notice] = "Please re-enter all data."
    end


  end



  def destroy

    cu = Stripe::Customer.retrieve(@credit_card.stripe_customer_id)
    cu.delete

    @credit_card.destroy

    respond_to do |format|
      format.html { redirect_to credit_cards_path, notice: 'Credit card info was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

  private
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end

end
