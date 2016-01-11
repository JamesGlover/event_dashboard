require 'test_helper'

class DashboardTest < ActiveSupport::TestCase

  test "should require a name" do
    db = build :dashboard, name: nil
    assert_not db.valid?
    assert_includes db.errors.full_messages, 'Name can\'t be blank'
  end

  test "should not require a password" do
    db = build :dashboard, password: nil
    assert db.valid?, "Dashboard was invalid"
  end

  test "should set the key to something sensible" do
    db = build :dashboard
    [
     ['simple','simple'],
     ['Downcase','downcase'],
     ['Space to underscore','space_to_underscore'],
     ['strip!@£$%specials','strip_specials'],
     ['Truncate to 20 characters','truncate_to_20_chara']
    ].each do |name,key|
      db.name = name
      assert_equal key, db.key
      assert db.valid?
    end
  end

  test 'should report false for password_protected? is password unset' do
    db = build :dashboard, password: nil
    assert_not db.password_protected?
  end

  test 'should report true for password_protected? is password set' do
    db = build :dashboard
    assert db.password_protected?
  end

  test 'should have no product lines by default' do
    db = build :dashboard
    assert_empty db.product_lines
  end

  test 'should store and retrieve product_lines' do
    db = create :dashboard
    pl = create :product_line, dashboard: db
    assert_includes db.product_lines, pl
  end

  test 'should destroy associated product_lines when destroyed' do
    db = create :dashboard
    pl = create :product_line, dashboard: db
    assert_equal 1, Dashboard.count
    assert_equal 1, ProductLine.count
    db.destroy
    assert_equal 0, Dashboard.count
    assert_equal 0, ProductLine.count
  end

end
