class RunsController < ApplicationController
  def create
    character = current_user.characters.find(params[:character_id])
    profile = character.game_profile || character.create_game_profile!
    run = Run.create_from_game_state(profile, params[:run][:stage], params[:run][:result], params[:run][:score])

    render json: { success: true, run: { id: run.id, score: run.score } }
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, errors: [ e.message ] }, status: :unprocessable_entity
  end
end
