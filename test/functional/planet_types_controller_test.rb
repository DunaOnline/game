require 'test_helper'

class PlanetTypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => PlanetType.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    PlanetType.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    PlanetType.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to planet_type_url(assigns(:planet_type))
  end

  def test_edit
    get :edit, :id => PlanetType.first
    assert_template 'edit'
  end

  def test_update_invalid
    PlanetType.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PlanetType.first
    assert_template 'edit'
  end

  def test_update_valid
    PlanetType.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PlanetType.first
    assert_redirected_to planet_type_url(assigns(:planet_type))
  end

  def test_destroy
    planet_type = PlanetType.first
    delete :destroy, :id => planet_type
    assert_redirected_to planet_types_url
    assert !PlanetType.exists?(planet_type.id)
  end
end
