class CoursesController < ApplicationController
  
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was created successfully" }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @course = Course.find(params[:id])
  end
  
  def study_word_list
    @course = Course.find(params[:id])
    @word_list = @course.word_list
    @words = @word_list.words.page params[:page]
    
    respond_to do |format|
      format.html { render 'courses/study_word_list' }
      format.js   { render 'courses/shuffle' }
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # White list
  def course_params
    params.require(:course).permit(:title, :summary, :level, :appx_length)
  end
end
