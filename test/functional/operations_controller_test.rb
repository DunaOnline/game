require 'test_helper'

class OperationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Operation.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Operation.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Operation.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to operation_url(assigns(:operation))
  end

  def test_edit
    get :edit, :id => Operation.first
    assert_template 'edit'
  end

  def test_update_invalid
    Operation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Operation.first
    assert_template 'edit'
  end

  def test_update_valid
    Operation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Operation.first
    assert_redirected_to operation_url(assigns(:operation))
  end

  def test_destroy
    operation = Operation.first
    delete :destroy, :id => operation
    assert_redirected_to operations_url
    assert !Operation.exists?(operation.id)
  end
end
