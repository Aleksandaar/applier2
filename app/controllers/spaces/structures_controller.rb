class Spaces::StructuresController < ApplicationController
  before_action :set_space
  before_action :set_structure, only: %i[ show edit update destroy ]

  def index
    @structures = Structure.all.page params[:page]
  end

  def show
    @form_fields = @structure.form_fields
  end

  def new
    @structure = Structure.new
  end

  def edit
  end

  def create
    params[:structure].merge!(space_id: params[:space_id])
    @structure = Structure.new(structure_params)

    if @structure.save
      redirect_to space_structures_path(@space), notice: "Structure was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @structure.update(structure_params)
      flash.now[:notice] = "Structure was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @structure.destroy!
    
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Structure was successfully destroyed." }
      format.html { redirect_to space_structures_path(@space), notice: "Structure was successfully destroyed.", status: :see_other }
    end
  end

  private
    def set_space
      @space = Space.find(params[:space_id])
    end

    def set_structure
      @structure = @space.structures.find(params.expect(:id))
    end

    def structure_params
      params.expect(structure: [ :space_id, :name, :content, :status ])
    end
end
