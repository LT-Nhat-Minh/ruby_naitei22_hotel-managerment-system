require "rails_helper"

RSpec.describe UsersController, type: :controller do
  before do
    # setup host cho mailer
    ActionMailer::Base.default_url_options[:host] = "http://localhost:3000"
  end

  let(:user) { create(:user) }

  describe "GET #show" do
    context "when user exists" do
      it "assigns the requested user to @user" do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when user does not exist" do
      it "redirects to root path" do
        get :show, params: { id: -1 }
        expect(response).to redirect_to(root_path)
      end

      it "sets warning flash" do
        get :show, params: { id: -1 }
        expect(flash[:warning]).to eq(I18n.t("users.not_found"))
      end
    end
  end

  describe "GET #new" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_params) { attributes_for(:user) }

      it "creates a new user" do
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(1)
      end

      it "redirects to root" do
        post :create, params: { user: valid_params }
        expect(response).to redirect_to(root_url)
      end

      it "sets flash info" do
        post :create, params: { user: valid_params }
        expect(flash[:info]).to eq(I18n.t("users.create.activate"))
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { attributes_for(:user, email: nil) }

      it "does not create a user" do
        expect {
          post :create, params: { user: invalid_params }
        }.not_to change(User, :count)
      end

      it "renders new" do
        post :create, params: { user: invalid_params }
        expect(response).to render_template(:new)
      end

      it "sets flash danger" do
        post :create, params: { user: invalid_params }
        expect(flash[:danger]).to eq(I18n.t("users.create.failure"))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the user" do
        put :update, params: { id: user.id, user: { name: "New Name" } }
        user.reload
        expect(user.name).to eq("New Name")
      end

      it "sets success flash" do
        put :update, params: { id: user.id, user: { name: "New Name" } }
        expect(flash[:success]).to eq(I18n.t("users.update.success"))
      end
    end

    context "with invalid params" do
      it "does not update the user" do
        put :update, params: { id: user.id, user: { email: nil } }
        user.reload
        expect(user.email).to eq(user.email)
      end

      it "renders edit" do
        put :update, params: { id: user.id, user: { email: nil } }
        expect(response).to render_template(:edit)
      end

      it "sets danger flash" do
        put :update, params: { id: user.id, user: { email: nil } }
        expect(flash[:danger]).to eq(I18n.t("users.update.failure"))
      end
    end
  end
end
