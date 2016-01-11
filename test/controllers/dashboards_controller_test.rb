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

end
