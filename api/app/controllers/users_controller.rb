class UsersController < ApplicationController
  respond_to :json

  def create
    user = User.new(user_params)

    if user.save
      login!(user)
      render status: 200, json: {
        user: user.as_json
      }
    else
      render status: 422, json: {
        error: "Unable to create user with supplied parameters",
        user: user.as_json
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
