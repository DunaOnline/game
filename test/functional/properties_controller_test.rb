require 'test_helper'

class PropertiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Property.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Property.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Property.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to property_url(assigns(:property))
  end

  def test_edit
    get :edit, :id => Property.first
    assert_template 'edit'
  end

  def test_update_invalid
    Property.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Property.first
    assert_template 'edit'
  end

  def test_update_valid
    Property.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Property.first
    assert_redirected_to property_url(assigns(:property))
  end

  def test_destroy
    property = Property.first
    delete :destroy, :id => property
    assert_redirected_to properties_url
    assert !Property.exists?(property.id)
  end
end
