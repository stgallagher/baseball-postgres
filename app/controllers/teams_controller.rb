class TeamsController < ApplicationController
  respond_to :json, :html

  def index
    @teams = Team.all
    @team = Team.find(3).players
    respond_with(@team) do |format|
      format.html
      format.json { render :json =>  Team.find(params[:team]).players  }
      format.any  { render :text => "only HTML, XML, and JSON format are supported at the moment." }
    end
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
