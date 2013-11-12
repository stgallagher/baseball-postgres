class ProfileProfilesController < ApplicationController
  def index
    @profiles = Profile.all
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.save
    redirect_to @profile, notice: "You have successfully create the profile #{@profile.name}"
  end

  def new
    @profile = Profile.new
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update_attributes(params[:profile].permit(:name))
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def destroy
    @profile = Profile.find(params[:id])
    profile_name = @profile.name
    @profile.destroy

    redirect_to profiles_path, notice: "You have successfully deleted #{profile_name}"
  end

  private
  def profile_params
    params.require(:profile).permit(:name)
  end
end
