class BankDetailsController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_bank_detail, only: [:show, :destroy]
  respond_to :html, :xml, :json


  def show
    redirect_to new_bank_detail_path unless @bank_detail
  end

  def new
    @bank_detail = current_user.build_bank_detail
  end

  def create
    @bank_detail = current_user.build_bank_detail(bank_detail_params)

    if params[:stripe_card_token]
      recipient = Stripe::Recipient.create(
        :name => params[:bank_detail][:full_name],
        :type => "individual",
        :card => params[:stripe_card_token]
      )

      stripe_response = JSON.parse("#{recipient}")

      if stripe_response["cards"]["data"][0]["id"].present?


        current_user.create_bank_detail(
          :stripe_recipient_token => stripe_response["id"],
          :full_name => params[:bank_detail][:full_name],
          :stripe_card_id_token => stripe_response["cards"]["data"][0]["id"],
          :card_number => stripe_response["cards"]["data"][0]["last4"]
        )
        # https://stripe.com/docs/api/ruby#update_transfer
        redirect_to bank_details_path, :notice => "Bank info was successfully created."
      end
    else
      flash.now[:notice] = "Something went wrong,please try again."
      render :new
    end
  rescue Stripe::InvalidRequestError => e
    flash[:notice] = "Stripe error while creating Recipient: #{e.message}"
    redirect_to :back
  end

  def destroy
    rp = Stripe::Recipient.retrieve(@bank_detail.stripe_recipient_token)
    rp.delete
    @bank_detail.destroy
    respond_to do |format|
      format.html { redirect_to bank_details_path, notice: 'Bank info was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

  private
    def set_bank_detail
      @bank_detail = current_user.bank_detail
    end

    def bank_detail_params
      params.require(:bank_detail).permit(:full_name, :card_number)
    end
end
