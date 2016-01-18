# frozen_string_literal: true
require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
    assert assigns(:dashboards).empty?
  end

  test "should list any present dashboards" do
    db = create :dashboard
    get :index
    assert_response :success
    assert_template :index
    assert_includes assigns(:dashboards), db
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "should show a dashboard" do
    db = create :dashboard
    get :show, :id => db.key
    assert_response :success
    assert_template :show
    assert_equal db, assigns(:dashboard)
  end

  test "should return a 404 if a dashboard doesn't exist" do
    get :show, :id => 'not_a_dashboard'
    assert_response :not_found
    assert_equal 'Not a dashboard', assigns(:dashboard_name)
    assert_equal 'not_a_dashboard', assigns(:dashboard_key)
    assert_template 'errors/dashboard_not_found'
  end

  test "should guard passworded dashboards" do
    db = create :protected_dashboard
    get :show, :id => db.key
    assert_redirected_to dashboard_login_path(db)
    assert_equal 'That dashboard is password protected.', flash["danger"]
  end

  test "should let people in is the session is set right" do
    db = create :protected_dashboard
    session['approved_dashboards'] = [db.key]
    get :show, :id => db.key
    assert_response :success
    assert_template :show
    assert_equal db, assigns(:dashboard)
  end

  test "should redirect people if the session has other keys" do
    db = create :protected_dashboard
    session['approved_dashboards'] = ['other_key']
    get :show, :id => db.key
    assert_redirected_to dashboard_login_path(db)
    assert_equal 'That dashboard is password protected.', flash["danger"]
  end

end
