class Campaigns::NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  before_action :set_note, only: [ :show, :edit, :update, :destroy ]

  def index
    @notes = @campaign.notes.where(user: current_user)
  end

  def new
    @note = @campaign.notes.new
  end

  def create
    @note = @campaign.notes.new(note_params.merge(user: current_user))
    if @note.save
      redirect_to campaign_notes_path(@campaign), notice: "Note created!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @note.update(note_params)
      redirect_to campaign_notes_path(@campaign), notice: "Note updated!"
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to campaign_notes_path(@campaign), notice: "Note deleted!"
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
