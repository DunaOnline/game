require 'test_helper'

class EodsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Eod.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Eod.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Eod.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to eod_url(assigns(:eod))
  end

  def test_edit
    get :edit, :id => Eod.first
    assert_template 'edit'
  end

  def test_update_invalid
    Eod.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Eod.first
    assert_template 'edit'
  end

  def test_update_valid
    Eod.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Eod.first
    assert_redirected_to eod_url(assigns(:eod))
  end

  def test_destroy
    eod = Eod.first
    delete :destroy, :id => eod
    assert_redirected_to eods_url
    assert !Eod.exists?(eod.id)
  end
end
