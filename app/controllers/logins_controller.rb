class LoginsController < ApplicationController

  def show
    @dashboard = Dashboard.find_by_key!(params[:dashboard_id])
  end

  def create
    @dashboard = Dashboard.find_by_key!(params[:dashboard_id])
    if @dashboard.authenticate params[:password]
      # Valid password
      (session['approved_dashboards'] ||= Set.new) << @dashboard.key
      flash['success'] = t(:logged_in,scope: :general)
      redirect_to dashboard_path(@dashboard)
    else
      # Invalid password
      flash['danger'] = t(:password_invalid,scope: :general)
      redirect_to dashboard_login_path(@dashboard)
    end
  end

  def destroy
    session['approved_dashboards'].delete(params[:dashboard_id])
    flash['success'] = t(:logged_out,scope: :general)
    redirect_to dashboards_path
  end
end
