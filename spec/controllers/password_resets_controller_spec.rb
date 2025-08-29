require "rails_helper"

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create(:user, activated: true) }

  describe "GET #new" do
    it "renders new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "email exists" do
      it "sets flash info" do
        post :create, params: { password_reset: { email: user.email } }
        expect(flash[:info]).to be_present
      end

      it "redirects to root" do
        post :create, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "email does not exist" do
      it "sets flash danger" do
        post :create, params: { password_reset: { email: "notfound@example.com" } }
        expect(flash[:danger]).to be_present
      end

      it "renders new" do
        post :create, params: { password_reset: { email: "notfound@example.com" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    before { user.create_reset_digest }

    it "renders edit for valid token" do
      get :edit, params: { id: user.reset_token, email: user.email }
      expect(response).to render_template(:edit)
    end

    it "redirects for invalid token" do
      get :edit, params: { id: "wrong", email: user.email }
      expect(response).to redirect_to(root_url)
    end
  end

  describe "PUT #update" do
    before { user.create_reset_digest }

    context "valid password" do
      it "sets flash success" do
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "newpassword", password_confirmation: "newpassword" } }
        expect(flash[:success]).to be_present
      end

      it "redirects to root" do
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "newpassword", password_confirmation: "newpassword" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "invalid password" do
      it "sets flash danger" do
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "short", password_confirmation: "mismatch" } }
        expect(flash[:danger]).to be_present
      end

      it "renders edit" do
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "short", password_confirmation: "mismatch" } }
        expect(response).to render_template(:edit)
      end
    end

    context "expired token" do
      it "sets flash danger" do
        allow_any_instance_of(User).to receive(:password_reset_expired?).and_return(true)
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "newpassword", password_confirmation: "newpassword" } }
        expect(flash[:danger]).to be_present
      end

      it "redirects to new_password_reset_url" do
        allow_any_instance_of(User).to receive(:password_reset_expired?).and_return(true)
        put :update, params: { id: user.reset_token, email: user.email,
                               user: { password: "newpassword", password_confirmation: "newpassword" } }
        expect(response).to redirect_to(new_password_reset_url)
      end
    end
  end
end
