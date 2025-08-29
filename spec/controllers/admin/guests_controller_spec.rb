# spec/controllers/admin/guests_controller_spec.rb
require "rails_helper"

RSpec.describe Admin::GuestsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:booking) { create(:booking, user: user) }
  let(:room) { create(:room) }
  let(:request_record) { create(:request, booking: booking, room: room, status: :checked_in) }
  let(:guest) { create(:guest, request: request_record) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #new" do
    before { get :new, params: { booking_id: booking.id, request_id: request_record.id } }

    it "assigns a new guest" do
      expect(assigns(:guest)).to be_a_new(Guest)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) do
        {
          full_name: "Nguyen Van A",
          identity_type: :national_id,
          identity_number: "123456789012",
          identity_issued_date: Date.today,
          identity_issued_place: "Hanoi"
        }
      end

      it "creates a new guest record" do
        expect do
          post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: valid_params }
        end.to change(Guest, :count).by(1)
      end

      it "redirects to the request show page" do
        post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: valid_params }
        expect(response).to redirect_to(admin_booking_request_path(booking, request_record))
      end

      it "sets flash success message" do
        post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: valid_params }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { full_name: "" } }

      it "does not create guest" do
        expect do
          post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: invalid_params }
        end.not_to change(Guest, :count)
      end

      it "renders new template" do
        post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: invalid_params }
        expect(response).to render_template(:new)
      end

      it "responds with unprocessable_entity status" do
        post :create, params: { booking_id: booking.id, request_id: request_record.id, guest: invalid_params }
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id } }

    it "assigns the requested guest" do
      expect(assigns(:guest)).to eq(guest)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:update_params) { { full_name: "Le Thi B" } }

      it "updates the guest full_name" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: update_params }
        expect(guest.reload.full_name).to eq("Le Thi B")
      end

      it "renders edit template" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: update_params }
        expect(response).to render_template(:edit)
      end

      it "sets flash success message" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: update_params }
        expect(flash.now[:success]).to be_present
      end
    end

    context "with invalid params" do
      let(:invalid_update) { { full_name: "" } }

      it "does not update the guest" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: invalid_update }
        expect(guest.reload.full_name).not_to eq("")
      end

      it "renders edit template" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: invalid_update }
        expect(response).to render_template(:edit)
      end

      it "responds with unprocessable_entity" do
        patch :update, params: { booking_id: booking.id, request_id: request_record.id, id: guest.id, guest: invalid_update }
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the guest" do
      guest_to_destroy = create(:guest, request: request_record)
      expect do
        delete :destroy, params: { booking_id: booking.id, request_id: request_record.id, id: guest_to_destroy.id }
      end.to change(Guest, :count).by(-1)
    end

    it "redirects to request show" do
      guest_to_destroy = create(:guest, request: request_record)
      delete :destroy, params: { booking_id: booking.id, request_id: request_record.id, id: guest_to_destroy.id }
      expect(response).to redirect_to(admin_booking_request_path(booking, request_record))
    end

    it "sets flash success message" do
      guest_to_destroy = create(:guest, request: request_record)
      delete :destroy, params: { booking_id: booking.id, request_id: request_record.id, id: guest_to_destroy.id }
      expect(flash[:success]).to be_present
    end
  end

  describe "before_actions" do
    it "redirects if request not found" do
      get :new, params: { booking_id: booking.id, request_id: 0 }
      expect(response).to redirect_to(admin_bookings_path)
    end

    it "sets flash danger if request not found" do
      get :new, params: { booking_id: booking.id, request_id: 0 }
      expect(flash[:danger]).to be_present
    end

    it "redirects if guest not found on edit" do
      get :edit, params: { booking_id: booking.id, request_id: request_record.id, id: 0 }
      expect(response).to redirect_to(admin_booking_request_path(booking.id, request_record))
    end

    it "sets flash danger if guest not found" do
      get :edit, params: { booking_id: booking.id, request_id: request_record.id, id: 0 }
      expect(flash[:danger]).to be_present
    end

    it "redirects if request not checked in on new" do
      request_record.update(status: :pending)
      get :new, params: { booking_id: booking.id, request_id: request_record.id }
      expect(response).to redirect_to(admin_booking_request_path(booking.id, request_record))
    end

    it "sets flash danger if request not checked in" do
      request_record.update(status: :pending)
      get :new, params: { booking_id: booking.id, request_id: request_record.id }
      expect(flash[:danger]).to be_present
    end
  end
end
