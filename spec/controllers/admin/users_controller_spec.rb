require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:booking1) { create(:booking, user: user) }
  let!(:booking2) { create(:booking, user: user) }

  before do
    # Giả lập admin login
    allow(controller).to receive(:current_user).and_return(admin)
    allow(controller).to receive(:logged_in?).and_return(true)
  end

  describe "GET #index" do
    before do
      # Mock ransack
      fake_ransack = double("ransack", result: User.all)
      allow(User).to receive(:with_total_created_bookings).and_return(User.all)
      allow(User).to receive(:ransack).and_return(fake_ransack)
    end

    it "assigns @users with paginated results" do
      get :index
      expect(assigns(:users)).to include(user)
    end

    it "responds successfully" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    context "when user exists" do
      before do
        # Mock ransack cho bookings
        bookings_relation = Booking.where(user_id: user.id)
        fake_ransack = double("ransack", result: bookings_relation)
        allow(Booking).to receive(:preload).and_return(bookings_relation)
        allow(bookings_relation).to receive(:by_booking_id).and_return(bookings_relation)
        allow(bookings_relation).to receive(:with_total_guests).and_return(bookings_relation)
        allow(bookings_relation).to receive(:with_total_price).and_return(bookings_relation)
        allow(bookings_relation).to receive(:ransack).and_return(fake_ransack)
      end

      it "assigns @user" do
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it "assigns @bookings" do
        get :show, params: { id: user.id }
        expect(assigns(:bookings)).to include(booking1, booking2)
      end

      it "responds successfully" do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user does not exist" do
      it "redirects to admin_users_path with flash danger" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:danger]).to eq(I18n.t("admin.users.not_found"))
      end
    end
  end
end
