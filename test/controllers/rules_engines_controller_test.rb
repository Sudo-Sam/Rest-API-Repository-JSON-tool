require 'test_helper'

class RulesEnginesControllerTest < ActionController::TestCase
  setup do
    @rules_engine = rules_engines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rules_engines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rules_engine" do
    assert_difference('RulesEngine.count') do
      post :create, rules_engine: { attribute: @rules_engine.attribute, color: @rules_engine.color, name: @rules_engine.name, operator: @rules_engine.operator, value: @rules_engine.value }
    end

    assert_redirected_to rules_engine_path(assigns(:rules_engine))
  end

  test "should show rules_engine" do
    get :show, id: @rules_engine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rules_engine
    assert_response :success
  end

  test "should update rules_engine" do
    patch :update, id: @rules_engine, rules_engine: { attribute: @rules_engine.attribute, color: @rules_engine.color, name: @rules_engine.name, operator: @rules_engine.operator, value: @rules_engine.value }
    assert_redirected_to rules_engine_path(assigns(:rules_engine))
  end

  test "should destroy rules_engine" do
    assert_difference('RulesEngine.count', -1) do
      delete :destroy, id: @rules_engine
    end

    assert_redirected_to rules_engines_path
  end
end
