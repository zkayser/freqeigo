class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show, :edit, :update, :destroy]

  # GET /subcategories
  # GET /subcategories.json
  def index
    @subcategories = Subcategory.all
  end

  # GET /subcategories/1
  # GET /subcategories/1.json
  def show
  end

  # GET /subcategories/new
  def new
    @subcategory = Subcategory.new(category: params[:category_id])
  end

  # GET /subcategories/1/edit
  def edit
  end

  # POST /subcategories
  # POST /subcategories.json
  def create
    @category = params[:category_id]
    @subcategory = Subcategory.new(subcategory_params.merge(category: @category))

    respond_to do |format|
      if @subcategory.save && @subcategory.category.save
        format.html { redirect_to @subcategory, notice: 'Subcategory was successfully created.' }
        format.json { render :show, status: :created, location: @subcategory }
      else
        format.html { render :new }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subcategories/1
  # PATCH/PUT /subcategories/1.json
  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        format.html { redirect_to @subcategory, notice: 'Subcategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @subcategory }
      else
        format.html { render :edit }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1
  # DELETE /subcategories/1.json
  def destroy
    @category = @subcategory.category || nil
    @subcategory.destroy
    if @category
    respond_to do |format|
      format.html { redirect_to category_subcategories_url(@category), notice: 'Subcategory was successfully destroyed.' }
      format.json { head :no_content }
    end
    else
      respond_to do |format|
        format.html { redirect_to categories_path }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subcategory_params
      params.require(:subcategory).permit(:subcategory, :category_attributes => [:id])
    end
end
