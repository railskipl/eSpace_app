class BankDetailsController < ApplicationController

 before_filter :authenticate_user!, :except => []
 before_action :set_bank_detail, only: [:show, :update, :destroy]
 respond_to :html, :xml, :json

  def index
    bank_detail = current_user.bank_detail
    if bank_detail.present?
      @bank_detail = bank_detail
    else
      redirect_to new_bank_detail_path
    end    
  end

  def show
    
  end

  def new
    @bank_detail = BankDetail.new 
  end

  def edit
    redirect_to bank_details_path
  end

  def create
        
        @bank_detail = BankDetail.new(bank_detail_params)

        if params[:stripe_card_token]
          

          begin

            recipient = Stripe::Recipient.create(
              :name => params[:bank_detail][:full_name],
              :type => "individual",
              :card => params[:stripe_card_token]
            )
   
            rescue Stripe::InvalidRequestError => e
    # "Stripe error while creating Recipient: #{e.message}"
            flash[:notice] = "Stripe error while creating Recipient: #{e.message}"
            redirect_to :back
            
            return false
          end
           
          stripe_response = JSON.parse("#{recipient}")
              
          if stripe_response["cards"]["data"][0]["id"].present?
            BankDetail.create(:stripe_recipient_token => stripe_response["id"], :full_name => params[:bank_detail][:full_name], :stripe_card_id_token => stripe_response["cards"]["data"][0]["id"], :card_number => stripe_response["cards"]["data"][0]["last4"], :user_id => params[:bank_detail][:user_id])
            # https://stripe.com/docs/api/ruby#update_transfer
            redirect_to bank_details_path, :notice => "Bank info was successfully created." 
            return false
          end

        else
          render :new
          flash[:notice] = "Something went wrong,please try again. "
        end
    
  end

  def update
    respond_to do |format|
      if @bank_detail.update(bank_detail_params)
        format.html { redirect_to edit_bank_detail_path(@bank_detail.id), notice: 'Bank info was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @bank_detail.errors, status: :unprocessable_entity }
      end
    end
    
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
      @bank_detail = BankDetail.find(params[:id])
    end

    def bank_detail_params
      params.require(:bank_detail).permit(:full_name, :card_number,:user_id)
    end
end
