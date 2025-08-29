# spec/controllers/admin/reviews_controller_spec.rb
require "rails_helper"

RSpec.describe Admin::ReviewsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:booking) { create(:booking, user: user) }
  let(:room) { create(:room) }
  let(:request_record) { create(:request, booking: booking, room: room, status: :checked_in) }
  let(:review) { create(:review, request: request_record, user: user) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #index" do
    let!(:review) { create(:review) }

    before { get :index }

    it "assigns @reviews" do
        expect(assigns(:reviews)).to be_present
    end

    it "assigns @pagy" do
        expect(assigns(:pagy)).to be_present
    end
  end

  describe "GET #show" do
    context "when review exists" do
      before { get :show, params: { id: review.id } }

      it "assigns the requested review" do
        expect(assigns(:review)).to eq(review)
      end
    end

    context "when review does not exist" do
      before { get :show, params: { id: 0 } }

      it "redirects to admin_reviews_path" do
        expect(response).to redirect_to(admin_reviews_path)
      end

      it "sets flash danger" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    context "with valid review_status" do
      it "updates the review status to approved" do
        patch :update, params: { id: review.id, review: { review_status: :approved } }
        expect(review.reload.review_status).to eq("approved")
      end

      it "sets approved_by to current_user" do
        patch :update, params: { id: review.id, review: { review_status: :approved } }
        expect(review.reload.approved_by).to eq(admin)
      end

      it "redirects to admin_review_path" do
        patch :update, params: { id: review.id, review: { review_status: :approved } }
        expect(response).to redirect_to(admin_review_path(review))
      end

      it "sets flash success" do
        patch :update, params: { id: review.id, review: { review_status: :approved } }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid review_status" do
      it "renders show template with unprocessable_entity" do
        allow_any_instance_of(Review).to receive(:update).and_return(false)
        patch :update, params: { id: review.id, review: { review_status: nil } }
        expect(response).to render_template(:show)
      end

      it "sets flash danger" do
        allow_any_instance_of(Review).to receive(:update).and_return(false)
        patch :update, params: { id: review.id, review: { review_status: nil } }
        expect(flash.now[:danger]).to be_present
      end
    end
  end

  describe "before_actions" do
    it "redirects to admin_reviews_path if review not found" do
      patch :update, params: { id: 0, review: { review_status: :approved } }
      expect(response).to redirect_to(admin_reviews_path)
    end

    it "sets flash danger if review not found" do
      patch :update, params: { id: 0, review: { review_status: :approved } }
      expect(flash[:danger]).to be_present
    end
  end
end
