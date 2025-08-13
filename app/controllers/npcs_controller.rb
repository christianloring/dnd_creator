class NpcsController < ApplicationController
  before_action :set_npc, only: %i[show edit update destroy]

  def index
    @npcs = current_user.npcs.order(created_at: :desc)
    add_breadcrumb "NPCs", npcs_path, active: true
  end

  def show
    add_breadcrumb "NPCs", npcs_path
    add_breadcrumb @npc.name, npc_path(@npc), active: true
  end

  def new
    @npc = current_user.npcs.build
    @categories = Npc::CATEGORIES
    add_breadcrumb "NPCs", npcs_path
    add_breadcrumb "New NPC", new_npc_path, active: true
  end

  def create
    Rails.logger.info "Raw params: #{params.inspect}"
    Rails.logger.info "NPC params: #{npc_params.inspect}"

    @npc = current_user.npcs.build(npc_params)

    if @npc.save
      Rails.logger.info "NPC saved successfully. Data: #{@npc.data.inspect}"
      redirect_to @npc, notice: "NPC created successfully."
    else
      Rails.logger.error "NPC save failed: #{@npc.errors.full_messages}"
      @categories = Npc::CATEGORIES
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Npc::CATEGORIES
    add_breadcrumb "NPCs", npcs_path
    add_breadcrumb @npc.name, npc_path(@npc)
    add_breadcrumb "Edit", edit_npc_path(@npc), active: true
  end

  def update
    if @npc.update(npc_params)
      redirect_to @npc, notice: "NPC updated successfully."
    else
      @categories = Npc::CATEGORIES
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @npc.destroy
    redirect_to npcs_path, notice: "NPC deleted successfully."
  end

  def randomize
    @npc = Npc.randomize
    @npc.user = current_user
    @categories = Npc::CATEGORIES
    add_breadcrumb "NPCs", npcs_path
    add_breadcrumb "Random NPC", randomize_npcs_path, active: true
    render :new
  end

  private

  def set_npc
    @npc = current_user.npcs.find(params[:id])
  end

  def npc_params
    params.require(:npc).permit(:name, data: {})
  end
end
