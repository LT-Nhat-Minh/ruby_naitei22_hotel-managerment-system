require "rails_helper"

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:booking) { create(:booking, user: user) }
  let(:request_record) { create(:request, booking: booking) }
  let(:review) { create(:review, user: user, request: request_record) }

  describe "GET #index" do
    context "when user exists" do
      it "assigns user's reviews to @reviews" do
        review
        get :index, params: { user_id: user.id }
        expect(assigns(:reviews)).to eq([review])
      end
    end

    context "when user does not exist" do
      it "redirects to root" do
        get :index, params: { user_id: -1 }
        expect(response).to redirect_to(root_path)
      end

      it "sets warning flash" do
        get :index, params: { user_id: -1 }
        expect(flash[:warning]).to eq(I18n.t("reviews.not_found"))
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        rating: 5,
        comment: "Great service",
        request_id: request_record.id,
        review_status: "approved"
      }
    end

    let(:invalid_params) { { rating: nil, comment: "" } }

    context "with valid attributes" do
      it "creates a new review" do
        expect {
          post :create, params: { user_id: user.id, review: valid_params }
        }.to change(Review, :count).by(1)
      end

      it "redirects to user bookings path" do
        post :create, params: { user_id: user.id, review: valid_params }
        expect(response).to redirect_to(user_bookings_path(user))
      end

      it "sets success flash" do
        post :create, params: { user_id: user.id, review: valid_params }
        expect(flash[:success]).to eq(I18n.t("reviews.create.success"))
      end
    end

    context "with invalid attributes" do
      it "does not create a review" do
        expect {
          post :create, params: { user_id: user.id, review: invalid_params }
        }.not_to change(Review, :count)
      end

      it "renders error flash" do
        post :create, params: { user_id: user.id, review: invalid_params }
        expect(flash[:error]).to eq(I18n.t("reviews.create.error"))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when review exists" do
      it "destroys the review" do
        review
        expect {
          delete :destroy, params: { user_id: user.id, id: review.id }
        }.to change(Review, :count).by(-1)
      end

      it "sets success flash" do
        delete :destroy, params: { user_id: user.id, id: review.id }
        expect(flash[:success]).to eq(I18n.t("reviews.destroy.success"))
      end
    end

    context "when review does not exist" do
      it "redirects to user reviews path" do
        delete :destroy, params: { user_id: user.id, id: -1 }
        expect(response).to redirect_to(user_reviews_path(user))
      end

      it "sets warning flash" do
        delete :destroy, params: { user_id: user.id, id: -1 }
        expect(flash[:warning]).to eq(I18n.t("reviews.not_found"))
      end
    end
  end
end
