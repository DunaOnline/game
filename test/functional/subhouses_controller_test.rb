require 'test_helper'

class SubhousesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Subhouse.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Subhouse.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Subhouse.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to subhouse_url(assigns(:subhouse))
  end

  def test_edit
    get :edit, :id => Subhouse.first
    assert_template 'edit'
  end

  def test_update_invalid
    Subhouse.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Subhouse.first
    assert_template 'edit'
  end

  def test_update_valid
    Subhouse.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Subhouse.first
    assert_redirected_to subhouse_url(assigns(:subhouse))
  end

  def test_destroy
    subhouse = Subhouse.first
    delete :destroy, :id => subhouse
    assert_redirected_to subhouses_url
    assert !Subhouse.exists?(subhouse.id)
  end
end
