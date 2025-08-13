class Campaigns::NotesController < ApplicationController
  before_action :set_campaign
  before_action :set_note, only: %i[show edit update destroy]

  def index
    @notes = @campaign.notes
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign)
    add_breadcrumb "Notes", campaign_notes_path(@campaign), active: true
  end

  def show
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign)
    add_breadcrumb "Notes", campaign_notes_path(@campaign)
    add_breadcrumb @note.title, campaign_note_path(@campaign, @note), active: true
  end

  def new
    @note = @campaign.notes.build
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign)
    add_breadcrumb "Notes", campaign_notes_path(@campaign)
    add_breadcrumb "New Note", new_campaign_note_path(@campaign), active: true
  end

  def create
    @note = @campaign.notes.build(note_params)
    if @note.save
      redirect_to campaign_note_path(@campaign, @note), notice: "Note created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign)
    add_breadcrumb "Notes", campaign_notes_path(@campaign)
    add_breadcrumb @note.title, campaign_note_path(@campaign, @note)
    add_breadcrumb "Edit", edit_campaign_note_path(@campaign, @note), active: true
  end

  def update
    if @note.update(note_params)
      redirect_to campaign_note_path(@campaign, @note), notice: "Note updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to campaign_notes_path(@campaign), notice: "Note deleted successfully."
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:campaign_id])
  end

  def set_note
    @note = @campaign.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
