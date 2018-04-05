# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)      default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  lastname           :string(255)
#  firstname          :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  cv_file_name       :string(255)
#  cv_content_type    :string(255)
#  cv_file_size       :integer
#  cv_updated_at      :datetime
#  status             :integer
#  manifestation_id   :integer
#  manifestation_type :string(255)
#  password_digest    :string(255)
#  activated          :boolean          default(FALSE), not null
#  admin              :boolean          default(FALSE), not null
#  alumni_email       :string(255)      default(""), not null
#

require 'rails_helper'

describe UsersController do

  let(:valid_attributes) { { "email" => "test@test.de", "firstname" => "Alex", "lastname" => "Musterwomen" } }
  let(:user) { FactoryBot.create(:user) }

  before :each do
   @user = FactoryBot.create(:user)
   login @user
  end

   describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, {id: @user.to_param}
      expect(assigns(:user)).to eq(@user)
    end

    it "should be accessible for the logged in user" do
      get :edit, {id: @user.to_param}
      assert_template :edit
    end

    it "should not be accessible for other users" do
      login FactoryBot.create(:user)
      get :edit, {id: @user.to_param}
      assert_redirected_to root_path
    end
  end

  describe "PUT update" do

    it "should be possible to update parameters of the logged in user" do
      put :update, {id: @user.to_param, user: valid_attributes}
      assert_redirected_to edit_user_path(@user)
    end

    it "should not be possible to update parameters of other users" do
      login FactoryBot.create(:user)
      put :update, {id: @user.to_param, user: valid_attributes}
      assert_redirected_to root_path
    end

    describe "with valid params" do
      it "updates the requested user" do
        expect_any_instance_of(User).to receive(:update).with({ "email" => "test100@test.com" })
        put :update, {id: @user.to_param, user: { email: "test100@test.com" }}
      end

      it "assigns the requested user as @user" do
        put :update, {id: @user.to_param, user: valid_attributes}
        expect(assigns(:user)).to eq(@user)
      end

      it "redirects to the edit user again" do
        put :update, {id: @user.to_param, user: valid_attributes}
        expect(response).to redirect_to(edit_user_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}
        expect(assigns(:user)).to eq(@user)
      end

      it "re-renders the 'edit' template" do
        allow_any_instance_of(User).to receive(:save).and_return(false)
        put :update, {id: @user.to_param, user: { email: "" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH update_password" do
    before(:each) do
      login user
    end

    it "assigns the current user as @user" do
      patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'} }
      expect(assigns(:user)).to eq(user)
    end

    it "redirects to user page" do
      patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'} }
      assert_redirected_to edit_user_path(user)
    end

    context "with valid passwords" do
      it "updates the password" do
        old_password_digest = user.password_digest
        patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'} }
        expect(user.reload.password_digest).not_to eq(old_password_digest)
      end

      it "displays success message" do
        patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'password'} }
        expect(flash[:success]).to eq(I18n.t('users.messages.password_changed'))
      end
    end

    context "with non-matching passwords" do
      it "doesn't update the password" do
        old_password_digest = user.password_digest
        patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'passwordd'} }
        expect(user.reload.password_digest).to eq(old_password_digest)
      end

      it "displays error message" do
        patch :update_password, { user_id: user.id, user: { old_password: 'password123', password: 'password', password_confirmation: 'passwordd'} }
        expect(flash[:error]).to eq(I18n.t('users.messages.passwords_not_matching'))
      end
    end

    context "with wrong old password" do
      it "doesn't update the password" do
        old_password_digest = user.password_digest
        patch :update_password, { user_id: user.id, user: { old_password: 'password1234', password: 'password', password_confirmation: 'password'} }
        expect(user.reload.password_digest).to eq(old_password_digest)
      end

      it "displays error message" do
        patch :update_password, { user_id: user.id, user: { old_password: 'password1234', password: 'password', password_confirmation: 'password'} }
        expect(flash[:error]).to eq(I18n.t('users.messages.password_wrong'))
      end
    end
  end

  describe "GET forgot_password" do
    before(:each) do
      login user
    end

    context "with blank email adress" do
      it "displays a notice" do
        post :forgot_password, { forgot_password: { email: '' } }
        expect(flash[:notice]).to eq(I18n.t('users.messages.unknown_email'))
      end
    end

    context "with valid email adress" do
      before(:each) do
        ActionMailer::Base.deliveries = []
      end

      it "redirects to root path" do
        post :forgot_password, { forgot_password: { email: user.email } }
        expect(response).to redirect_to(root_path)
      end

      it "displays success message" do
        post :forgot_password, { forgot_password: { email: user.email } }
        expect(flash[:notice]).to eq(I18n.t('users.messages.password_resetted'))
      end

      it "sends mail with new password" do
        post :forgot_password, { forgot_password: { email: user.email } }
        expect(ActionMailer::Base.deliveries.first.to.count).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to[0]).to eq(user.email)
      end

      it "sets new password" do
        old_password_digest = user.password_digest
        post :forgot_password, { forgot_password: { email: user.email } }
        expect(user.reload.password_digest).not_to eq(old_password_digest)
      end

      it "ignores cases" do
        post :forgot_password, { forgot_password: { email: user.email.swapcase } }
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to[0]).to eq(user.email)
      end
    end
  end
end
