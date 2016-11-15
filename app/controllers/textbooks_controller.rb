class TextbooksController < ApplicationController
  before_action :set_textbook, only: [:show, :edit, :update, :destroy]
  
  def index
    @textbooks = Textbook.all.to_a
  end

  def show
  end

  def new
    @textbook = Textbook.new
  end

  def create
    @textbook = Textbook.new(textbook_params)

    respond_to do |format|
      if @textbook.save
        format.html { redirect_to @textbook, notice: 'Textbook was successfully created.' }
        format.json { render :show, status: :created, location: @textbook }
      else
        format.html { render :new }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @textbook.update(textbook_params)
        format.html { redirect_to @textbook, notice: 'Textbook was successfully updated.' }
        format.json { render :show, status: :ok, location: @textbook }
      else
        format.html { render :edit }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end
  
  private
    def set_textbook
      @textbook = Textbook.find(params[:id])
    end
    
    def textbook_params
      params.require(:textbook).permit(:title, :table_of_contents, :course_id,
        :lessons_attributes => [:id, :title,
        :objectives_attributes => [:id, :name, :content]])
    end
end
