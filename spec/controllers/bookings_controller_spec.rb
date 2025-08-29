require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:room) { create(:room) }
  let!(:request_record) { create(:request, room: room) }

  # Mock current_user
  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    let!(:booking) { create(:booking, user: user) }

    it "renders index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @bookings" do
      get :index
      expect(assigns(:bookings)).to include(booking)
    end
  end

  describe "GET #current_booking" do
    let!(:draft_booking) { create(:booking, user: user, status: :draft) }

    it "renders current_booking template" do
      get :current_booking
      expect(response).to render_template(:current_booking)
    end

    it "assigns @current_booking" do
      get :current_booking
      expect(assigns(:current_booking)).to eq(draft_booking)
    end
  end

#   describe "PATCH #update" do
#     let!(:booking) { create(:booking, user: user, status: :draft) }
#     let!(:request_record) { create(:request, booking: booking, room: room, note: "Default request note") }

#     it "updates booking attributes" do
#         patch :update, params: { id: booking.id, booking: { requests_attributes: [{ id: request_record.id, note: "Updated" }] } }
#         expect(request_record.reload.note).to eq("Updated")
#     end

#     it "redirects to current_booking_bookings_path" do
#         patch :update, params: { id: booking.id, booking: { requests_attributes: [{ id: request_record.id, note: "Updated" }] } }
#         expect(response).to redirect_to(current_booking_bookings_path(locale: I18n.locale))
#     end
#   end

  describe "DELETE #destroy" do
    let!(:booking) { create(:booking, user: user) }

    it "reduces booking count by 1" do
      expect {
        delete :destroy, params: { id: booking.id }
      }.to change(Booking, :count).by(-1)
    end

    it "redirects to current_booking_bookings_path" do
      delete :destroy, params: { id: booking.id }
      expect(response).to redirect_to(current_booking_bookings_path)
    end
  end

  describe "PATCH #confirm_booking" do
    let!(:booking) { create(:booking, user: user, status: :draft) }
    let!(:request_record) { create(:request, booking: booking, room: room) }

    it "assigns booking code and status if no overlap" do
      patch :confirm_booking, params: { id: booking.id }
      expect(booking.reload.status).to eq("pending")
    end
  end

  describe "PATCH #cancel" do
    let!(:draft_booking) { create(:booking, user: user, status: :draft) }
    let!(:pending_booking) { create(:booking, user: user, status: :pending) }
    let!(:completed_booking) { create(:booking, user: user, status: :confirmed) }

    it "updates status to cancelled for draft" do
      patch :cancel, params: { user_id: user.id, id: draft_booking.id }
      expect(draft_booking.reload.status).to eq("cancelled")
    end

    it "updates status to cancelled for pending" do
      patch :cancel, params: { user_id: user.id, id: pending_booking.id }
      expect(pending_booking.reload.status).to eq("cancelled")
    end

    it "does not change status if not draft or pending" do
      patch :cancel, params: { user_id: user.id, id: completed_booking.id }
      expect(completed_booking.reload.status).to eq("confirmed")
    end
  end
end
