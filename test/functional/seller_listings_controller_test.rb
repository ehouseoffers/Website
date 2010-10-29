require 'test_helper'

class SellerListingsControllerTest < ActionController::TestCase
  setup do
    @seller_listing = seller_listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seller_listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seller_listing" do
    assert_difference('SellerListing.count') do
      post :create, :seller_listing => @seller_listing.attributes
    end

    assert_redirected_to seller_listing_path(assigns(:seller_listing))
  end

  test "should show seller_listing" do
    get :show, :id => @seller_listing.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @seller_listing.to_param
    assert_response :success
  end

  test "should update seller_listing" do
    put :update, :id => @seller_listing.to_param, :seller_listing => @seller_listing.attributes
    assert_redirected_to seller_listing_path(assigns(:seller_listing))
  end

  test "should destroy seller_listing" do
    assert_difference('SellerListing.count', -1) do
      delete :destroy, :id => @seller_listing.to_param
    end

    assert_redirected_to seller_listings_path
  end
end
