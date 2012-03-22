require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Vote.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Vote.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Vote.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to vote_url(assigns(:vote))
  end

  def test_edit
    get :edit, :id => Vote.first
    assert_template 'edit'
  end

  def test_update_invalid
    Vote.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Vote.first
    assert_template 'edit'
  end

  def test_update_valid
    Vote.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Vote.first
    assert_redirected_to vote_url(assigns(:vote))
  end

  def test_destroy
    vote = Vote.first
    delete :destroy, :id => vote
    assert_redirected_to votes_url
    assert !Vote.exists?(vote.id)
  end
end
