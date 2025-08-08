class CharactersController < ApplicationController
  before_action :set_character, only: %i[show edit update destroy]

  def index
    @characters = current_user.characters
  end

  def show; end

  def new
    @character = current_user.characters.build
  end

  def create
    @character = current_user.characters.build(character_params)
    if @character.save
      redirect_to @character, notice: "Character created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @character.update(character_params)
      redirect_to @character, notice: "Character updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy
    redirect_to characters_path, notice: "Character deleted."
  end

  private

  def set_character
    @character = current_user.characters.find(params[:id])
  end

  def character_params
    params.require(:character).permit(
      :name, :character_class, :subclass, :species, :level,
      :strength, :dexterity, :constitution,
      :intelligence, :wisdom, :charisma,
      :profile_picture
    )
  end
end
