class BankDetailsController < ApplicationController
  before_action :set_bank_detail, only: [:show, :edit, :update, :destroy]

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
    @bank_detail = BankDetail.new(bank_detail_params)

    respond_to do |format|
      if @bank_detail.save
        format.html { redirect_to bank_details_path, notice: 'Bank info was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @bank_detail.errors, status: :unprocessable_entity }
      end
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
      params.require(:bank_detail).permit(:full_name, :card_number)
    end
end
