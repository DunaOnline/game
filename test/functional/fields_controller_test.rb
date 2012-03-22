require 'test_helper'

class FieldsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Field.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Field.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Field.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to field_url(assigns(:field))
  end

  def test_edit
    get :edit, :id => Field.first
    assert_template 'edit'
  end

  def test_update_invalid
    Field.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Field.first
    assert_template 'edit'
  end

  def test_update_valid
    Field.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Field.first
    assert_redirected_to field_url(assigns(:field))
  end

  def test_destroy
    field = Field.first
    delete :destroy, :id => field
    assert_redirected_to fields_url
    assert !Field.exists?(field.id)
  end
end
