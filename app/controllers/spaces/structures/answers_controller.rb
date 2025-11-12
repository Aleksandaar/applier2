class Spaces::Structures::AnswersController < ApplicationController
  before_action :set_space_and_structure
  before_action :set_answer, only: %i[ show edit update destroy download ]

  def index
    @answers = @structure.answers.page params[:page]
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @structure.answers.new(answer_params)

    if @answer.save
      @answer = Answer.new
      flash.now[:notice] = "Thank you for the submission."

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Thank you for the submission." }
        format.html { render :new }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "There are issues with the form." }
        format.html { render :new }
      end
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = "Answer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy!
    
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Answer was successfully destroyed." }
      format.html { redirect_to answers_path, notice: "Answer was successfully destroyed.", status: :see_other }
    end
  end

  def download
    send_data(@answer.file_data, :type => @answer.content_type, :filename => "#{@answer.filename}", :disposition => "inline")
  end

  private
    def set_space_and_structure
        @space = Space.find(params[:space_id])
        @structure = @space.structures.find(params.expect(:structure_id))
    end

    def set_answer
      @answer = Answer.find(params.expect(:id))
    end

    def answer_params
      params.expect(answer: [ :structure_id, :status, :stared, :file_data, form_data: {} ])
    end
end
