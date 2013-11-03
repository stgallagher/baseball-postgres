class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def create
    @player = Player.new(player_params)
    @player.save
    redirect_to @player, notice: "You have successfully create the player #{@player.name}"
  end

  def new
    @player = Player.new
  end

  def update
    @player = Player.find(params[:id])
    @player.update_attributes(params[:player].permit(:name))
  end

  def edit
    @player = Player.find(params[:id])
  end

  def show
    @player = Player.find(params[:id])
  end

  def destroy
    @player = Player.find(params[:id])
    player_name = @player.name
    @player.destroy

    redirect_to players_path, notice: "You have successfully deleted #{player_name}"
  end

  private
  def player_params
    params.require(:player).permit(:name)
  end

end
