require 'test_helper'

class QasControllerTest < ActionController::TestCase
  setup do
    @qa = qas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:qas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create qa" do
    assert_difference('Qa.count') do
      post :create, :qa => @qa.attributes
    end

    assert_redirected_to qa_path(assigns(:qa))
  end

  test "should show qa" do
    get :show, :id => @qa.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @qa.to_param
    assert_response :success
  end

  test "should update qa" do
    put :update, :id => @qa.to_param, :qa => @qa.attributes
    assert_redirected_to qa_path(assigns(:qa))
  end

  test "should destroy qa" do
    assert_difference('Qa.count', -1) do
      delete :destroy, :id => @qa.to_param
    end

    assert_redirected_to qas_path
  end
end
