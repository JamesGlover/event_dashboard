require './lib/dictionary_suggest'

class DashboardsController < ApplicationController

  before_action :confirm_permissions, except: [:index, :new]

  def index
    @dashboards = Dashboard.all
  end

  def show
  end

  def new
  end

  def delete
  end

  def update
  end

  private

  def confirm_permissions
    @dashboard = Dashboard.where(key:params[:id]).include_configuration.first
    return dashboard_not_found! if @dashboard.nil?
    return true unless @dashboard.password_protected?
    return true if session.fetch('approved_dashboards',[]).include? @dashboard.key
    flash['danger'] = t(:password_required,scope: :general)
    redirect_to dashboard_login_path(@dashboard)
    false
  end

  def dashboard_not_found!
    @dashboard_name = params[:id].humanize
    @dashboard_key = params[:id]
    dashboards_list = Dashboard.limit(100).select(:key,:name).all
    dictionary = DictionarySuggest.new(dashboards_list)
    @suggested_dashboards = dictionary.matches(params[:id])
    render 'errors/dashboard_not_found', status: :not_found
  end

end
