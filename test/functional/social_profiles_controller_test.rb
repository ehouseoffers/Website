require 'test_helper'

class SocialProfilesControllerTest < ActionController::TestCase
  setup do
    @social_profile = social_profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:social_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create social_profile" do
    assert_difference('SocialProfile.count') do
      post :create, :social_profile => @social_profile.attributes
    end

    assert_redirected_to social_profile_path(assigns(:social_profile))
  end

  test "should show social_profile" do
    get :show, :id => @social_profile.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @social_profile.to_param
    assert_response :success
  end

  test "should update social_profile" do
    put :update, :id => @social_profile.to_param, :social_profile => @social_profile.attributes
    assert_redirected_to social_profile_path(assigns(:social_profile))
  end

  test "should destroy social_profile" do
    assert_difference('SocialProfile.count', -1) do
      delete :destroy, :id => @social_profile.to_param
    end

    assert_redirected_to social_profiles_path
  end
end
