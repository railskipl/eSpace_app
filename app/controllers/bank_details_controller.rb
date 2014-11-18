class BankDetailsController < ApplicationController

 before_filter :authenticate_user!, :except => []
 before_action :set_bank_detail, only: [:show, :edit, :update, :destroy]
 respond_to :html, :xml, :json

  def index
    @bank_details = BankDetail.all
    
  end

  def show
    
  end

  def new
    @bank_detail = BankDetail.new
    
  end

  def edit
  end

  def create
    
    # @bank_detail = BankDetail.new(bank_detail_params)

    # respond_to do |format|
    #   if @bank_detail.save
    #     format.html { redirect_to bank_details_path, notice: 'Bank info was successfully created.' }
    #     format.json { render :show, status: :created, location: @post }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @bank_detail.errors, status: :unprocessable_entity }
    #   end
    # end

        
        @bank_detail = BankDetail.new(bank_detail_params)

        if params[:stripe_card_token]
   
          begin
            recipient = Stripe::Recipient.create(
              :name => params[:bank_detail][:full_name],
              :type => "individual",
              :email => "payee@example.com",
              :card => params[:stripe_card_token]
            )
          
          rescue Stripe::InvalidRequestError => e
            redirect_to :back, :notice => "Stripe error while creating Recipient: #{e.message}" 
            return false
          end

          stripe_response = JSON.parse("#{recipient}")

          if stripe_response["cards"]["data"][0]["id"].present?
            @bank_detail.stripe_recipient_token = stripe_response["id"]
            @bank_detail.full_name = params[:bank_detail][:full_name]
            @bank_detail.stripe_card_id_token = stripe_response["cards"]["data"][0]["id"]
            @bank_detail.card_number = stripe_response["cards"]["data"][0]["last4"]
            @bank_detail.user_id = params[:bank_detail][:user_id]
            @bank_detail.save

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
        format.html { redirect_to bank_details_path, notice: 'Bank info was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @bank_detail.errors, status: :unprocessable_entity }
      end
    end
    
  end

  def destroy
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
