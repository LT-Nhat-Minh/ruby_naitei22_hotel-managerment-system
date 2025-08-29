require "rails_helper"

RSpec.describe RoomsController, type: :controller do
  let(:room_type) { create(:room_type, price: 100) }
  let(:room) { create(:room, room_type: room_type) }

  describe "GET #index" do
    it "returns success response" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "assigns @rooms" do
      room # tạo room trước
      get :index
      expect(assigns(:rooms)).to include(room)
    end

    it "renders index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "when room exists" do
      it "returns success response" do
        get :show, params: { id: room.id }
        expect(response).to have_http_status(:ok)
      end

      it "assigns @room" do
        get :show, params: { id: room.id }
        expect(assigns(:room)).to eq(room)
      end

      it "assigns @amenities" do
        amenity = create(:amenity)
        room.amenities << amenity
        get :show, params: { id: room.id }
        expect(assigns(:amenities)).to include(amenity)
      end

    #   it "assigns @reviews only approved" do
    #     approved_review = create(:review, request: create(:request, room: room), review_status: :approved)
    #     rejected_review = create(:review, request: create(:request, room: room), review_status: :rejected)
    #     get :show, params: { id: room.id }
    #     expect(assigns(:reviews)).to include(approved_review)
    #     # (mỗi expect tách ra, ở đây gom vì liên quan review filter)
    #   end

    #   it "assigns @available_dates" do
    #     availability = create(:room_availability, room: room, available_date: Date.today, is_available: true)
    #     get :show, params: { id: room.id }
    #     expect(assigns(:available_dates)).to include(availability.available_date)
    #   end
    end

    context "when room not found" do
      it "redirects to root" do
        get :show, params: { id: 999999 }
        expect(response).to redirect_to(root_path)
      end

      it "sets flash warning" do
        get :show, params: { id: 999999 }
        expect(flash[:warning]).to be_present
      end
    end
  end

  describe "GET #calculate_price" do
    before do
      create(:room_availability, room: room, available_date: Date.today, price: 100)
      create(:room_availability, room: room, available_date: Date.today + 1, price: 150)
    end

    context "with valid dates" do
    #   it "returns success json" do
    #     get :calculate_price, params: { id: room.id, check_in: Date.today.to_s, check_out: (Date.today + 1).to_s }
    #     expect(response).to have_http_status(:ok)
    #   end

    #   it "returns total_price" do
    #     get :calculate_price, params: { id: room.id, check_in: Date.today.to_s, check_out: (Date.today + 1).to_s }
    #     json = JSON.parse(response.body)
    #     expect(json["total_price"]).to eq(250)
    #   end

    #   it "returns nights" do
    #     get :calculate_price, params: { id: room.id, check_in: Date.today.to_s, check_out: (Date.today + 1).to_s }
    #     json = JSON.parse(response.body)
    #     expect(json["nights"]).to eq(1)
    #   end
    end

    context "with invalid dates" do
    #   it "returns unprocessable_entity" do
    #     get :calculate_price, params: { id: room.id, check_in: "2025-12-10", check_out: "2025-12-01" }
    #     expect(response).to have_http_status(:unprocessable_entity)
    #   end

    #   it "returns error json" do
    #     get :calculate_price, params: { id: room.id, check_in: "abc", check_out: "xyz" }
    #     json = JSON.parse(response.body)
    #     expect(json["success"]).to eq(false)
    #   end
    end
  end
end
