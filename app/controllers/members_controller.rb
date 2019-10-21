class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  before_action :require_login
  def index
    @pagy, @members = if params[:name] 
                          pagy(Member.where('name LIKE ?', "%#{params[:name]}%"), items: 15)      
                      else               
                        pagy(Member.all, items: 15)
                      end
  end

  # GET /members/1
  # GET /members/1.json
  before_action :require_login
  def show
    if(Receipt.maximum("number") == nil)
      @new_receipt_number = 0
    else 
      @new_receipt_number = Receipt.maximum("number") + 1 ;
    end
    @pagy, @receipts = pagy(@member.receipts.all.order(number: :desc), items: 6);
  end

  # GET /members/new
  before_action :require_login
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  before_action :require_login
  def edit
  end

  # POST /members
  # POST /members.json
  before_action :require_login
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  before_action :require_login
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  before_action :require_login
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :address, :phone)
    end
end
