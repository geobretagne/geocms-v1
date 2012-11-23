class SessionsController < ApplicationController
  layout "backend"
  def new
  end

  def create
    user = login(params[:username], params[:password], params[:remember_me])
    if user && ActsAsTenant.current_tenant.users.find_by_username(params[:username])
      redirect_back_or_to backend_root_url, :notice => "Logged in!"
    else
      redirect_to login_path, :notice => "Email or password was invalid."
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
end

