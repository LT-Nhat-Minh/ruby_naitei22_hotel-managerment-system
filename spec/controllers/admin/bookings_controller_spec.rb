# spec/controllers/admin/bookings_controller_spec.rb
require "rails_helper"

RSpec.describe Admin::BookingsController, type: :controller do
  let!(:admin_user) { create(:user, role: "admin") }
  let!(:booking) { create(:booking, status: "draft", booking_code: "BK1001") }

  before do
    # Stub current_user là admin
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

#   describe "GET #index" do
#     it "assigns @bookings" do
#       get :index
#       expect(assigns(:bookings)).to include(booking)
#       expect(response).to have_http_status(:ok)
#     end
#   end

  describe "GET #show" do
    context "when booking exists" do
    #   it "assigns @booking" do
    #     get :show, params: { id: booking.id }
    #     expect(assigns(:booking)).to eq(booking)
    #   end

    #   it "responds successfully" do
    #     get :show, params: { id: booking.id }
    #     expect(response).to have_http_status(:ok)
    #   end
    end

    context "when booking does not exist" do
      it "redirects to index with flash danger" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to(admin_bookings_path)
        expect(flash[:danger]).to eq(I18n.t("admin.bookings.not_found"))
      end
    end
  end

#   describe "PATCH #update_status" do
#     context "with valid status" do
#       it "updates the booking status" do
#         patch :update_status, params: { id: booking.id, booking: { status: "confirmed" } }
#         expect(booking.reload.status).to eq("confirmed")
#       end

#       it "redirects to show with flash success" do
#         patch :update_status, params: { id: booking.id, booking: { status: "confirmed" } }
#         expect(response).to redirect_to(admin_booking_path(booking))
#         expect(flash[:success]).to eq(I18n.t("admin.bookings.success"))
#       end
#     end

#     context "with invalid status" do
#       it "renders show with unprocessable_entity" do
#         allow_any_instance_of(Booking).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(booking))
#         patch :update_status, params: { id: booking.id, booking: { status: "invalid_status" } }
#         expect(response).to have_http_status(:unprocessable_entity)
#       end
#     end
#   end

#   describe "PATCH #decline" do
#     context "with valid decline params" do
#       let(:decline_reason) { "Room not available" }

#       it "updates status and decline_reason" do
#         patch :decline, params: { id: booking.id, booking: { status: "declined", decline_reason: decline_reason } }
#         booking.reload
#         expect(booking.status).to eq("declined")
#         expect(booking.decline_reason).to eq(decline_reason)
#       end

#       it "redirects to show with flash success" do
#         patch :decline, params: { id: booking.id, booking: { status: "declined", decline_reason: decline_reason } }
#         expect(response).to redirect_to(admin_booking_path(booking))
#         expect(response).to have_http_status(:see_other)
#         expect(flash[:success]).to eq(I18n.t("admin.bookings.success"))
#       end
#     end

#     context "with invalid decline params" do
#       it "renders decline with unprocessable_entity" do
#         allow_any_instance_of(Booking).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(booking))
#         patch :decline, params: { id: booking.id, booking: { status: "declined", decline_reason: nil } }
#         expect(response).to have_http_status(:unprocessable_entity)
#       end
#     end
#   end

#   describe "GET #show_decline" do
#     it "renders decline template without layout" do
#       get :show_decline, params: { id: booking.id }
#       expect(response).to render_template(:show_decline)
#       expect(response).to_not render_template(layout: true)
#     end
#   end
end
