class BankDetailsController < ApplicationController
  before_action :set_bank_detail, only: [:show, :edit, :update, :destroy]
 respond_to :html, :xml, :json
  def index
    @bank_details = BankDetail.all
    
  end

  def show
    respond_with(@bank_detail)
  end

  def new
    @bank_detail = BankDetail.new
    
  end

  def edit
  end

  def create
    @bank_detail = BankDetail.new(bank_detail_params)
    @bank_detail.save
    respond_with(@bank_detail)
  end

  def update
    @bank_detail.update(bank_detail_params)
    respond_with(@bank_detail)
  end

  def destroy
    @bank_detail.destroy
    respond_with(@bank_detail)
  end

  private
    def set_bank_detail
      @bank_detail = BankDetail.find(params[:id])
    end

    def bank_detail_params
      params.require(:bank_detail).permit(:full_name, :card_number)
    end
end
