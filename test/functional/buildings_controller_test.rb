require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Building.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Building.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Building.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to building_url(assigns(:building))
  end

  def test_edit
    get :edit, :id => Building.first
    assert_template 'edit'
  end

  def test_update_invalid
    Building.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Building.first
    assert_template 'edit'
  end

  def test_update_valid
    Building.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Building.first
    assert_redirected_to building_url(assigns(:building))
  end

  def test_destroy
    building = Building.first
    delete :destroy, :id => building
    assert_redirected_to buildings_url
    assert !Building.exists?(building.id)
  end
end
