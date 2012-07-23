require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  setup do
    @poll = polls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:polls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create poll" do
    assert_difference('Poll.count') do
      post :create, poll: @poll.attributes
    end

    assert_redirected_to poll_path(assigns(:poll))
  end

  test "should show poll" do
    get :show, id: @poll.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @poll.to_param
    assert_response :success
  end

  test "should update poll" do
    put :update, id: @poll.to_param, poll: @poll.attributes
    assert_redirected_to poll_path(assigns(:poll))
  end

  test "should destroy poll" do
    assert_difference('Poll.count', -1) do
      delete :destroy, id: @poll.to_param
    end

    assert_redirected_to polls_path
  end
end
