require 'test_helper'

class EffectsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Effect.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Effect.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Effect.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to effect_url(assigns(:effect))
  end

  def test_edit
    get :edit, :id => Effect.first
    assert_template 'edit'
  end

  def test_update_invalid
    Effect.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Effect.first
    assert_template 'edit'
  end

  def test_update_valid
    Effect.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Effect.first
    assert_redirected_to effect_url(assigns(:effect))
  end

  def test_destroy
    effect = Effect.first
    delete :destroy, :id => effect
    assert_redirected_to effects_url
    assert !Effect.exists?(effect.id)
  end
end
