class DashboardsController < ApplicationController

  def index
    @dashboards = Dashboard.all
  end

  def show
    @dashboard = Dashboard.where(key:params[:id]).first
  end

  def new
  end

  def delete
  end

  def update
  end

end
