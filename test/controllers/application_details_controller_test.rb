require 'test_helper'

class ApplicationDetailsControllerTest < ActionController::TestCase
  setup do
    @application_detail = application_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:application_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create application_detail" do
    assert_difference('ApplicationDetail.count') do
      post :create, application_detail: { environment: @application_detail.environment, name: @application_detail.name, request_hdr: @application_detail.request_hdr, request_text: @application_detail.request_text, rest_method: @application_detail.rest_method, uri: @application_detail.uri }
    end

    assert_redirected_to application_detail_path(assigns(:application_detail))
  end

  test "should show application_detail" do
    get :show, id: @application_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @application_detail
    assert_response :success
  end

  test "should update application_detail" do
    patch :update, id: @application_detail, application_detail: { environment: @application_detail.environment, name: @application_detail.name, request_hdr: @application_detail.request_hdr, request_text: @application_detail.request_text, rest_method: @application_detail.rest_method, uri: @application_detail.uri }
    assert_redirected_to application_detail_path(assigns(:application_detail))
  end

  test "should destroy application_detail" do
    assert_difference('ApplicationDetail.count', -1) do
      delete :destroy, id: @application_detail
    end

    assert_redirected_to application_details_path
  end
end
