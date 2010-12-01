require 'test_helper'

class BulletPointsControllerTest < ActionController::TestCase
  setup do
    @bullet_point = bullet_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bullet_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bullet_point" do
    assert_difference('BulletPoint.count') do
      post :create, :bullet_point => @bullet_point.attributes
    end

    assert_redirected_to bullet_point_path(assigns(:bullet_point))
  end

  test "should show bullet_point" do
    get :show, :id => @bullet_point.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bullet_point.to_param
    assert_response :success
  end

  test "should update bullet_point" do
    put :update, :id => @bullet_point.to_param, :bullet_point => @bullet_point.attributes
    assert_redirected_to bullet_point_path(assigns(:bullet_point))
  end

  test "should destroy bullet_point" do
    assert_difference('BulletPoint.count', -1) do
      delete :destroy, :id => @bullet_point.to_param
    end

    assert_redirected_to bullet_points_path
  end
end
