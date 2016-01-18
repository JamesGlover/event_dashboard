# frozen_string_literal: true
require 'test_helper'

class LoginsControllerTest < ActionController::TestCase

  test "a get with a dashboard should render okay" do
    db = create :protected_dashboard
    get :show, :dashboard_id => db.key
    assert_template :show
    assert_equal db, assigns(:dashboard)
  end

  test "a post with an invalid password should redirect the user with an error" do
    db = create :protected_dashboard
    post :create, :dashboard_id => db.key, :password => 'invalid'
    assert_redirected_to dashboard_login_path(db)
    assert_equal 'The password you provided was incorrect.', flash["danger"]
  end

  test "a post with an valid password should redirect the user to the correct page and add the dashboard to the session" do
    db = create :protected_dashboard, key: 'dashboard_key'
    post :create, :dashboard_id => db.key, :password => 'secret_password'
    assert_redirected_to dashboard_path(db)
    assert_includes session['approved_dashboards'], 'dashboard_key'
    assert_equal 'You can now view this dashboard.', flash["success"]
  end
end
