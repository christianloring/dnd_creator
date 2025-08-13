class EncountersController < ApplicationController
  before_action :require_authentication
  before_action :set_encounter, only: [ :show, :destroy ]

  def index
    @encounters = Encounter.where(user_id: current_user.id)
    add_breadcrumb "Encounters", encounters_path, active: true
  end

  def new
    @request = EncounterRequest.new(party_level: 5, party_size: 4, shape: "boss_minions", difficulty: "medium")
    add_breadcrumb "Encounters", encounters_path
    add_breadcrumb "New Encounter", new_encounter_path, active: true
  end

  def create
    @request = EncounterRequest.new(encounter_params)
    if @request.valid?
      result = EncounterBuilder.new.call(@request)

      encounter = Encounter.create!(
        user: current_user,
        inputs: @request.attributes,
        composition: serialize_result(result),
        total_xp: result.total_xp_budget,
        theme: @request.theme
      )

      session[:last_encounter] = {
        request: @request.attributes,
        result: serialize_result(result)
      }

      redirect_to encounter_path(encounter)
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    begin
      session_data = session[:last_encounter]
      if session_data &&
         session_data[:request] &&
         session_data[:request]["party_level"] &&
         @encounter.inputs &&
         @encounter.inputs["party_level"] &&
         session_data[:request]["party_level"] == @encounter.inputs["party_level"]
        data = session_data.with_indifferent_access
        @request = EncounterRequest.new(data[:request])
        @result = deserialize_result(data[:result])
      else
        @request = EncounterRequest.new(@encounter.inputs || {})
        @result = deserialize_result(@encounter.composition || {})
      end

      add_breadcrumb "Encounters", encounters_path
      add_breadcrumb "Encounter Details", encounter_path(@encounter), active: true
    rescue => e
      Rails.logger.error "Error in encounters#show: #{e.message}"
      redirect_to encounters_path, alert: "Unable to load encounter details. Please try again."
    end
  end

  def destroy
    @encounter.destroy
    redirect_to encounters_path, notice: "Encounter deleted successfully."
  end

  private

  def set_encounter
    @encounter = Encounter.find(params[:id])
  end

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
    return EncounterBuilder::Result.new(total_xp_budget: 0, monsters: [], notes: []) unless h

    h = h.with_indifferent_access
    EncounterBuilder::Result.new(
      total_xp_budget: h[:total_xp_budget] || 0,
      monsters: (h[:monsters] || []).map { |m| EncounterBuilder::MonsterPick.new(**m.symbolize_keys) },
      notes: h[:notes] || []
    )
  end
end
