class Spaces::Structures::ResponseTemplatesController < ApplicationController
  before_action :set_space_and_structure
  before_action :set_response_template, only: %i[ show edit update destroy ]

  def index
    @response_templates = @structure.response_templates.page params[:page]
  end

  def show
  end

  def new
    @response_template = ResponseTemplate.new
  end

  def edit
  end

  def create
    @response_template = @structure.response_templates.new(response_template_params)

    if @response_template.save
      redirect_to space_structure_response_templates_path, notice: "Response Template was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @response_template.update(response_template_params)
      flash.now[:notice] = "Response Template was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @response_template.destroy!
    
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Response Template was successfully destroyed." }
      format.html { redirect_to space_structure_response_templates_path, notice: "Response Template was successfully destroyed.", status: :see_other }
    end
  end

  private

  def set_space_and_structure
      @space = Space.find(params[:space_id])
      @structure = @space.structures.find(params.expect(:structure_id))
  end
  
    
    def set_response_template
      @response_template = ResponseTemplate.find(params.expect(:id))
    end

    def response_template_params
      params.expect(response_template: [ :subject, :status, :content_html, :content_text, :enabled ])
    end
end
