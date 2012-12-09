require 'test_helper'

class ProjectControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get link" do
    get :link
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

end
