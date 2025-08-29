# spec/controllers/admin/requests_controller_spec.rb
require "rails_helper"

RSpec.describe Admin::RequestsController, type: :controller do
  let(:admin) { create(:user, role: :admin) }
  let(:user) { create(:user) }
  let(:room_type) { create(:room_type) }
  let(:room) { create(:room, room_type: room_type) }
  let(:booking) { create(:booking, user: user) }
  let!(:request_record) { create(:request, booking: booking, room: room) }

  before do
    # Giả lập current_user là admin
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #show" do
    it "assigns @request and renders show template" do
      get :show, params: { booking_id: booking.id, id: request_record.id }
      expect(assigns(:request)).to eq(request_record)
      expect(response).to render_template(:show)
    end

    it "redirects if request not found" do
      get :show, params: { booking_id: booking.id, id: 0 }
      expect(flash[:danger]).to be_present
      expect(response).to redirect_to(admin_booking_path(booking.id))
    end
  end

  describe "PATCH #update" do
    context "when valid update" do
      it "updates request status and redirects" do
        patch :update, params: { booking_id: booking.id, id: request_record.id,
                                 request: { status: :confirmed } }
        expect(request_record.reload.status).to eq("confirmed")
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(admin_booking_request_path(booking, request_record))
      end
    end

    context "when invalid update due to validate_check_out" do
      before do
        request_record.guests.destroy_all
        request_record.update(status: :checked_out)
      end

      it "does not update and renders show with danger flash" do
        patch :update, params: { booking_id: booking.id, id: request_record.id,
                                 request: { status: :checked_out } }
        expect(response).to render_template(:show)
        expect(flash[:danger]).to be_present
      end
    end

    context "when update fails" do
      it "renders show with unprocessable_entity" do
        allow_any_instance_of(Request).to receive(:update).and_return(false)
        patch :update, params: { booking_id: booking.id, id: request_record.id,
                                 request: { status: :confirmed } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:show)
        expect(flash.now[:danger]).to be_present
      end
    end
  end
end
