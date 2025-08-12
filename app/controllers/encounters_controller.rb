class EncountersController < ApplicationController
  def index
    @encounters = Encounter.where(user_id: current_user.id)
  end

  def new
    @request = EncounterRequest.new(party_level: 5, party_size: 4, shape: "boss_minions", difficulty: "medium")
  end

  def create
    @request = EncounterRequest.new(encounter_params)
    if @request.valid?
      result = EncounterBuilder.new.call(@request)
      session[:last_encounter] = {
        request: @request.attributes,
        result: serialize_result(result)
      }
      redirect_to encounter_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    data = session[:last_encounter]
    redirect_to new_encounter_path and return unless data

    data = data.with_indifferent_access  # or deep_symbolize_keys
    @request = EncounterRequest.new(data[:request])
    @result  = deserialize_result(data[:result])
  end

  private

  def encounter_params
    params.require(:encounter_request).permit(:party_level, :party_size, :shape, :difficulty, :theme)
  end

  def serialize_result(r)
    {
      total_xp_budget: r.total_xp_budget,
      monsters: r.monsters.map { |m| m.to_h },
      notes: r.notes
    }
  end

  def deserialize_result(h)
    h = h.with_indifferent_access
    EncounterBuilder::Result.new(
      total_xp_budget: h[:total_xp_budget],
      monsters: h[:monsters].map { |m| EncounterBuilder::MonsterPick.new(**m.symbolize_keys) },
      notes: h[:notes]
    )
  end
end
