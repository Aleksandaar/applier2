class Spaces::Structures::FormFieldsController < ApplicationController
  before_action :set_space_and_structure
  before_action :set_form_field, only: %i[ show edit update destroy ]

  def index
    @form_fields = @structure.form_fields.page params[:page]
  end

  def show
  end

  def new
    @form_field = FormField.new
  end

  def edit
  end

  def create
    @form_field = @structure.form_fields.new(form_field_params)

    if @form_field.save
      redirect_to space_structure_form_fields_path, notice: "Form field was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @form_field.update(form_field_params)
      flash.now[:notice] = "Form field was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @form_field.destroy!
    
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Form field was successfully destroyed." }
      format.html { redirect_to space_structure_form_fields_path, notice: "Form field was successfully destroyed.", status: :see_other }
    end
  end

  private

  def set_space_and_structure
      @space = Space.find(params[:space_id])
      @structure = @space.structures.find(params.expect(:structure_id))
  end
  
    
    def set_form_field
      @form_field = FormField.find(params.expect(:id))
    end

    def form_field_params
      params.expect(form_field: [ :label, :field_type, :position, :required ])
    end
end
