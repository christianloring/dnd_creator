class CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[show edit update destroy]

  def index
    @campaigns = current_user.campaigns
    add_breadcrumb "Campaigns", campaigns_path, active: true
  end

  def show
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign), active: true
  end

  def new
    @campaign = current_user.campaigns.build
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb "New Campaign", new_campaign_path, active: true
  end

  def create
    @campaign = current_user.campaigns.build(campaign_params)
    if @campaign.save
      redirect_to @campaign, notice: "Campaign created successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    add_breadcrumb "Campaigns", campaigns_path
    add_breadcrumb @campaign.name, campaign_path(@campaign)
    add_breadcrumb "Edit", edit_campaign_path(@campaign), active: true
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: "Campaign updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign deleted successfully."
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :description)
  end
end
