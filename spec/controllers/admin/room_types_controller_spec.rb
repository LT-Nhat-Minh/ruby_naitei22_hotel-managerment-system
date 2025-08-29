require "rails_helper"

RSpec.describe Admin::RoomTypesController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:room_type) { create(:room_type) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe "GET #index" do
    it "assigns @room_types" do
      get :index
      expect(assigns(:room_types)).to include(room_type)
    end

    it "assigns @pagy" do
      get :index
      expect(assigns(:pagy)).to be_present
    end

    it "responds successfully" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "assigns a new RoomType" do
      get :new
      expect(assigns(:room_type)).to be_a_new(RoomType)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { room_type: { name: "Deluxe", description: "Nice room", price: 100 } } }

      it "creates a new room_type" do
        expect { post :create, params: valid_params }.to change(RoomType, :count).by(1)
      end

      it "redirects to index" do
        post :create, params: valid_params
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash success" do
        post :create, params: valid_params
        expect(flash[:success]).to eq(I18n.t("admin.room_types.create_success"))
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { room_type: { name: "" } } }

      it "does not create room_type" do
        expect { post :create, params: invalid_params }.not_to change(RoomType, :count)
      end

      it "renders new" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "sets flash danger" do
        post :create, params: invalid_params
        expect(flash.now[:danger]).to eq(I18n.t("admin.room_types.create_error"))
      end
    end
  end

  describe "GET #edit" do
    context "when room_type exists" do
      it "assigns @room_type" do
        get :edit, params: { id: room_type.id }
        expect(assigns(:room_type)).to eq(room_type)
      end
    end

    context "when room_type does not exist" do
      it "redirects to index" do
        get :edit, params: { id: 0 }
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash danger" do
        get :edit, params: { id: 0 }
        expect(flash[:danger]).to eq(I18n.t("admin.room_types.load_room_type.not_found"))
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:update_params) { { id: room_type.id, room_type: { name: "Updated" } } }

      it "updates the room_type name" do
        patch :update, params: update_params
        expect(room_type.reload.name).to eq("Updated")
      end

      it "redirects to index" do
        patch :update, params: update_params
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash success" do
        patch :update, params: update_params
        expect(flash[:success]).to eq(I18n.t("admin.room_types.update_success"))
      end
    end

    context "with invalid params" do
      let(:invalid_update_params) { { id: room_type.id, room_type: { name: "" } } }

      it "does not update the room_type" do
        patch :update, params: invalid_update_params
        expect(room_type.reload.name).not_to eq("")
      end

      it "renders edit" do
        patch :update, params: invalid_update_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "sets flash danger" do
        patch :update, params: invalid_update_params
        expect(flash.now[:danger]).to eq(I18n.t("admin.room_types.update_error"))
      end
    end

    context "when room_type does not exist" do
      it "redirects to index" do
        patch :update, params: { id: 0, room_type: { name: "Test" } }
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash danger" do
        patch :update, params: { id: 0, room_type: { name: "Test" } }
        expect(flash[:danger]).to eq(I18n.t("admin.room_types.load_room_type.not_found"))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when room_type exists" do
      it "destroys the room_type" do
        expect { delete :destroy, params: { id: room_type.id } }.to change(RoomType, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: room_type.id }
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash success" do
        delete :destroy, params: { id: room_type.id }
        expect(flash[:success]).to eq(I18n.t("admin.room_types.destroy_success"))
      end
    end

    context "when room_type does not exist" do
      it "redirects to index" do
        delete :destroy, params: { id: 0 }
        expect(response).to redirect_to(admin_room_types_path)
      end

      it "sets flash danger" do
        delete :destroy, params: { id: 0 }
        expect(flash[:danger]).to eq(I18n.t("admin.room_types.load_room_type.not_found"))
      end
    end
  end
end
