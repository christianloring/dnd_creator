class CharactersController < ApplicationController
  before_action :set_character, only: %i[show edit update destroy play update_game_profile reset_game_profile]

  def index
    @characters = current_user.characters
    add_breadcrumb "Characters", characters_path, active: true
  end

  def show
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character), active: true
  end

  def new
    @character = current_user.characters.build
    add_breadcrumb "Characters", characters_path
    add_breadcrumb "New Character", new_character_path, active: true
  end

  def create
    @character = current_user.characters.build(character_params)
    if @character.save
      redirect_to @character, notice: "Character created successfully."
    else
              render :new, status: :unprocessable_content
    end
  end

  def edit
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Edit", edit_character_path(@character), active: true
  end

  def update
    if @character.update(character_params)
      redirect_to @character, notice: "Character updated successfully."
    else
              render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @character.destroy
    redirect_to characters_path, notice: "Character deleted."
  end

  def play
    @game_profile = @character.game_profile || @character.create_game_profile!
    add_breadcrumb "Characters", characters_path
    add_breadcrumb @character.name, character_path(@character)
    add_breadcrumb "Play", play_character_path(@character), active: true
  end

  def update_game_profile
    @game_profile = @character.game_profile || @character.create_game_profile!

    if @game_profile.update(game_profile_params)
      leveled_up = @game_profile.check_level_up
      render json: { success: true, leveled_up:, game_profile: {
        level: @game_profile.level, exp: @game_profile.exp,
        hp_current: @game_profile.hp_current, max_hp: @game_profile.max_hp,
        gold: @game_profile.gold, data: @game_profile.data
      } }
    else
              render json: { success: false, errors: @game_profile.errors.full_messages }, status: :unprocessable_content
    end
  end

  def reset_game_profile
    @game_profile = @character.game_profile || @character.create_game_profile!
    @game_profile.reset_progress

    render json: { success: true, message: "Game progress reset successfully" }
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
      :profile_picture, :hitpoints, :speed
    )
  end

  def game_profile_params
    params.require(:game_profile).permit(:level, :exp, :hp_current, :max_hp, :gold, data: {})
  end
end
