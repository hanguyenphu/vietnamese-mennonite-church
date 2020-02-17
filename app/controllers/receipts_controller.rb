class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  # GET /receipts.json
  before_action :require_login
  def index
    @pagy, @receipts = if params[:member_name] 
                  @all_receipt = []
                  @members = Member.where('lower(name) Like ?', "%#{params[:member_name].downcase}%" )
                  if(@members.size >= 1)
                    pagy(@members.first.receipts.all.order(number: :desc), items: 15)
                  else 
                    pagy(Receipt.where('member_id = 0'))
                  end

              else               
                pagy(Receipt.all.order(number: :desc), items: 15)
             
              end
     @years = Receipt.order(donation_year: :desc).distinct.pluck(:donation_year)
     @number_of_receipt = Hash.new
     @total_amount_each_year_array= Hash.new
     @years.each {
        |year| @year_receipts = Receipt.where(:donation_year => year )
        @total_amount_each_year =  @year_receipts.map(&:amount).sum
        @total_receipts_each_year = @year_receipts.count
        @number_of_receipt[year] = @total_receipts_each_year
        @total_amount_each_year_array[year] = @total_amount_each_year
     }         
  end

  # GET /receipts/1
  # GET /receipts/1.json
  before_action :require_login
  def show
    @receipt = Receipt.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = ReceiptPdf.new(@receipt)
        send_data pdf.render, filename: "Receipt_#{@receipt.number}.pdf", 
                              type: "application/pdf",
                              disposition: "inline"
                             
      end
    end
  end

  # GET /receipts/new
  before_action :require_login
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  before_action :require_login
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  before_action :require_login
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to "/members/#{@receipt.member_id}", notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  before_action :require_login
  def update
    respond_to do |format|
     
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  before_action :require_login
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to "/members/#{@receipt.member_id}", notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:number, :donation_year, :amount, :description, :member_id, :member_name)
    end
end
