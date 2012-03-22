require 'test_helper'

class PlanetsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Planet.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Planet.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Planet.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to planet_url(assigns(:planet))
  end

  def test_edit
    get :edit, :id => Planet.first
    assert_template 'edit'
  end

  def test_update_invalid
    Planet.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Planet.first
    assert_template 'edit'
  end

  def test_update_valid
    Planet.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Planet.first
    assert_redirected_to planet_url(assigns(:planet))
  end

  def test_destroy
    planet = Planet.first
    delete :destroy, :id => planet
    assert_redirected_to planets_url
    assert !Planet.exists?(planet.id)
  end
end
