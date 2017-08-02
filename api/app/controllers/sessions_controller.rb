class SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by_credentials(user_params)

    if user
      login!(user)
      render status: 200, json: user.to_json
    else
      render status: 422, json: {
        error: "Username or password incorrect"
      }
    end
  end

  def destroy
    logout!
    render status: 200, json: {
      success: "Session destroyed"
    }
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
