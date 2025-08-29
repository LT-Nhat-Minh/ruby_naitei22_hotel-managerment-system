require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:room) { create(:room) }
  let!(:booking) { create(:booking, user: user) }

  let!(:pending_request) { create(:request, booking: booking, room: room, status: :pending) }
  let!(:draft_request)   { create(:request, booking: booking, room: room, status: :draft) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe "DELETE #destroy" do
    it "destroys the request" do
      expect {
        delete :destroy, params: { id: pending_request.id }
      }.to change { Request.count }.by(-1)
    end

    it "redirects to current_booking_bookings_path with locale" do
      delete :destroy, params: { id: pending_request.id }
      expect(response).to redirect_to(current_booking_bookings_path(locale: I18n.locale))
    end

    it "redirects to root_path if request not found" do
      delete :destroy, params: { id: 0 }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PUT #cancel" do
    context "when request is pending" do
      it "updates request status to cancelled" do
        put :cancel, params: { id: pending_request.id, user_id: user.id }
        expect(pending_request.reload.status).to eq("cancelled")
      end

      it "redirects back to user_bookings_path with locale" do
        put :cancel, params: { id: pending_request.id, user_id: user.id }
        expect(response).to redirect_to(user_bookings_path(user, locale: I18n.locale))
      end
    end

    context "when request is not pending" do
      it "does not cancel the request" do
        put :cancel, params: { id: draft_request.id, user_id: user.id }
        expect(draft_request.reload.status).to eq("draft")
      end

      it "redirects back to user_bookings_path with alert" do
        put :cancel, params: { id: draft_request.id, user_id: user.id }
        expect(flash[:alert]).to be_present
      end
    end

    context "when request not found" do
      it "redirects to root_path" do
        put :cancel, params: { id: 0, user_id: user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
