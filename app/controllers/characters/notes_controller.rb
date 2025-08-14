class Characters::NotesController < ApplicationController
  before_action :set_character
  before_action :set_note, only: %i[show edit update destroy]

  def index
    @notes = @character.notes
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Notes", character_notes_path(@character), active: true
  end

  def show
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Notes", character_notes_path(@character)
    add_breadcrumb @note.title, character_note_path(@character, @note), active: true
  end

  def new
    @note = @character.notes.build
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Notes", character_notes_path(@character)
    add_breadcrumb "New Note", new_character_note_path(@character), active: true
  end

  def create
    @note = @character.notes.build(note_params)
    if @note.save
      redirect_to character_note_path(@character, @note), notice: "Note created successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Notes", character_notes_path(@character)
    add_breadcrumb @note.title, character_note_path(@character, @note)
    add_breadcrumb "Edit", edit_character_note_path(@character, @note), active: true
  end

  def update
    if @note.update(note_params)
      redirect_to character_note_path(@character, @note), notice: "Note updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @note.destroy
    redirect_to character_notes_path(@character), notice: "Note deleted successfully."
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
