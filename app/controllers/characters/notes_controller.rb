class Characters::NotesController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_character
  before_action :set_note, only: [ :show, :edit, :update, :destroy ]

  def index
    @notes = @character.notes.where(user: current_user)
  end

  def new
    @note = @character.notes.new
  end

  def create
    @note = @character.notes.new(note_params.merge(user: current_user))
    if @note.save
      redirect_to character_notes_path(@character), notice: "Note created!"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @note.update(note_params)
      redirect_to character_notes_path(@character), notice: "Note updated!"
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to character_notes_path(@character), notice: "Note deleted!"
  end

  private

  def set_character
    @character = current_user.characters.find(params[:character_id])
  end

  def set_note
    @note = @character.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
