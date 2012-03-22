require 'test_helper'

class SystemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => System.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    System.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    System.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to system_url(assigns(:system))
  end

  def test_edit
    get :edit, :id => System.first
    assert_template 'edit'
  end

  def test_update_invalid
    System.any_instance.stubs(:valid?).returns(false)
    put :update, :id => System.first
    assert_template 'edit'
  end

  def test_update_valid
    System.any_instance.stubs(:valid?).returns(true)
    put :update, :id => System.first
    assert_redirected_to system_url(assigns(:system))
  end

  def test_destroy
    system = System.first
    delete :destroy, :id => system
    assert_redirected_to systems_url
    assert !System.exists?(system.id)
  end
end
