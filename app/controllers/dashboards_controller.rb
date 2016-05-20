require './lib/dictionary_suggest'

class DashboardsController < ApplicationController

  before_action :confirm_permissions, except: [:index, :new, :create]

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

  def create
    new_db = Dashboard.create(clean_params)
    ActiveRecord::Base.transaction do
      if new_db.save
        # If we're password protected, log in immediately
        (session['approved_dashboards'] ||= Set.new) << new_db.key if new_db.password_protected?
        redirect_to edit_dashboard_path(new_db)
      else
        flash['danger'] = new_db.errors.full_messages
        redirect_to new_dashboard_path
      end
    end
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

   def clean_params
    params.required(:dashboard).permit(:password,:name,:password_confirmation)
  end

end
