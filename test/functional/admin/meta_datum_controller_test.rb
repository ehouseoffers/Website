require 'test_helper'

class Admin::MetaDatumControllerTest < ActionController::TestCase
  setup do
    @admin_meta_datum = admin_meta_datum(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_meta_datum)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_meta_datum" do
    assert_difference('Admin::MetaData.count') do
      post :create, :admin_meta_datum => @admin_meta_datum.attributes
    end

    assert_redirected_to admin_meta_datum_path(assigns(:admin_meta_datum))
  end

  test "should show admin_meta_datum" do
    get :show, :id => @admin_meta_datum.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_meta_datum.to_param
    assert_response :success
  end

  test "should update admin_meta_datum" do
    put :update, :id => @admin_meta_datum.to_param, :admin_meta_datum => @admin_meta_datum.attributes
    assert_redirected_to admin_meta_datum_path(assigns(:admin_meta_datum))
  end

  test "should destroy admin_meta_datum" do
    assert_difference('Admin::MetaData.count', -1) do
      delete :destroy, :id => @admin_meta_datum.to_param
    end

    assert_redirected_to admin_meta_data_path
  end
end
