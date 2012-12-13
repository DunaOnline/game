require 'test_helper'

class SyselaadsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Syselaad.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Syselaad.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Syselaad.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to syselaad_url(assigns(:syselaad))
  end

  def test_edit
    get :edit, :id => Syselaad.first
    assert_template 'edit'
  end

  def test_update_invalid
    Syselaad.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Syselaad.first
    assert_template 'edit'
  end

  def test_update_valid
    Syselaad.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Syselaad.first
    assert_redirected_to syselaad_url(assigns(:syselaad))
  end

  def test_destroy
    syselaad = Syselaad.first
    delete :destroy, :id => syselaad
    assert_redirected_to syselaads_url
    assert !Syselaad.exists?(syselaad.id)
  end
end
