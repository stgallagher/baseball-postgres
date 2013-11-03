class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def create
    @team = Team.new(team_params)
    @team.save
    redirect_to @team, notice: "You have successfully create the team #{@team.name}"
  end

  def new
    @team = Team.new
  end

  def update
    @team = Team.find(params[:id])
    @team.update_attributes(params[:team].permit(:name))
    redirect_to teams_path
  end

  def edit
    @team = Team.find(params[:id])
  end

  def show
    @team = Team.find(params[:id])
  end

  def destroy
    @team = Team.find(params[:id])
    team_name = @team.name
    @team.destroy

    redirect_to teams_path, notice: "You have successfully deleted #{team_name}"
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
end
