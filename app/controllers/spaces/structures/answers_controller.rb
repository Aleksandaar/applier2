class Spaces::Structures::AnswersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:new, :create]

  before_action :set_answer, only: %i[ show edit update destroy download ]
  before_action :set_space_and_structure
  before_action :ensure_user_logged_in, only: [:show]

  before_action :allow_iframe_headers, only: [:new, :create]

  def index
    @answers = @structure.answers.page params[:page]
  end

  def show
    @messages = @answer.messages
      .includes(:author)
      .order(:created_at)

    @new_message = Message.new(structure_id: @structure.id, answer_id: @answer.id)
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
      flash.now[:success] = "Thank you for the submission."

      respond_to do |format|
        format.turbo_stream { flash.now[:success] = "Thank you for the submission." }
        format.html { render :new }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:error] = "There are issues with the form." }
        format.html { render :new }
      end
    end
  end

  def update
    if @answer.update(answer_params)
      @show_answer = true if (answer_params.keys - ["status"]).blank?
      flash.now[:notice] = "Answer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy!
    
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Answer was successfully destroyed." }
      format.html { redirect_to space_structure_answer_path(@space, @structure, @answer), notice: "Answer was successfully destroyed.", status: :see_other }
    end
  end

  def download
    send_data(@answer.file_data, :type => @answer.content_type, :filename => "#{@answer.filename}", :disposition => "inline")
  end

  private
    def allow_iframe_headers
      headers['X-Frame-Options'] = 'ALLOWALL'
    end

    def ensure_user_logged_in
      if !user_signed_in? && @answer.user.present?
        sign_in(@answer.user)
      end
    end

    def set_space_and_structure
      if @answer.present?
        @structure = @answer.structure
        @space = @structure.space
      else
        @space = Space.find(params[:space_id])
        @structure = @space.structures.find(params.expect(:structure_id))
      end
    end

    def set_answer
      @answer = Answer.find_by(id: params[:id]) || Answer.find_by(token: params[:token])
    end

    def answer_params
      params.expect(answer: [ :structure_id, :status, :stared, :file_data, form_data: {} ])
    end
end
