class CharactersController < ApplicationController
  before_action :set_character, only: %i[show edit update destroy play update_game_profile reset_game_profile]
  before_action :set_character_for_runs, only: %i[runs]

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

  def play
    @character = current_user.characters.find(params[:id])
    @game_profile = @character.game_profile || @character.create_game_profile!
  end

  def update_game_profile
    @character = current_user.characters.find(params[:id])
    @game_profile = @character.game_profile || @character.create_game_profile!

    # Update the game profile with the provided data
    if @game_profile.update(game_profile_params)
      # The update already includes the new exp, so check for level up
      leveled_up = @game_profile.check_level_up

              render json: {
          success: true,
          leveled_up: leveled_up,
          game_profile: {
            level: @game_profile.level,
            exp: @game_profile.exp,
            hp_current: @game_profile.hp_current,
            max_hp: @game_profile.max_hp,
            gold: @game_profile.gold,
            data: @game_profile.data
          }
        }
    else
      render json: { success: false, errors: @game_profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reset_game_profile
    @character = current_user.characters.find(params[:id])
    @game_profile = @character.game_profile || @character.create_game_profile!
    @game_profile.reset_progress

    render json: { success: true, message: "Game progress reset successfully" }
  end

  def runs
    @character = current_user.characters.find(params[:character_id])
    @game_profile = @character.game_profile || @character.create_game_profile!

    run = Run.create_from_game_state(
      @game_profile,
      params[:run][:stage],
      params[:run][:result],
      params[:run][:score]
    )

    if run.persisted?
      render json: { success: true, run: { id: run.id, score: run.score } }
    else
      render json: { success: false, errors: run.errors.full_messages }, status: :unprocessable_entity
    end
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
    params.require(:game_profile).permit(:level, :exp, :hp_current, :gold, data: {})
  end

  def set_character_for_runs
    @character = current_user.characters.find(params[:character_id])
  end
end
