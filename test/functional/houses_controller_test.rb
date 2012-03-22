require 'test_helper'

class HousesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => House.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    House.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    House.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to house_url(assigns(:house))
  end

  def test_edit
    get :edit, :id => House.first
    assert_template 'edit'
  end

  def test_update_invalid
    House.any_instance.stubs(:valid?).returns(false)
    put :update, :id => House.first
    assert_template 'edit'
  end

  def test_update_valid
    House.any_instance.stubs(:valid?).returns(true)
    put :update, :id => House.first
    assert_redirected_to house_url(assigns(:house))
  end

  def test_destroy
    house = House.first
    delete :destroy, :id => house
    assert_redirected_to houses_url
    assert !House.exists?(house.id)
  end
end
