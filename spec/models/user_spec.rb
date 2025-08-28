# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:approved_reviews).class_name("Review").with_foreign_key("approved_by_id").dependent(:nullify) }
    it { is_expected.to have_many(:status_changed_bookings).class_name("Booking").with_foreign_key("status_changed_by_id").dependent(:nullify) }
  end

  describe "validations" do
    context "when name is missing" do
      it "is invalid" do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
      end
    end

    context "when email is missing" do
      it "is invalid" do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end
    end

    context "when email format is invalid" do
      it "is invalid" do
        user = build(:user, email: "invalid_email")
        expect(user).not_to be_valid
      end
    end

    context "when email is duplicate" do
      it "is invalid" do
        create(:user, email: "test@example.com")
        user = build(:user, email: "test@example.com")
        expect(user).not_to be_valid
      end
    end

    context "when name length exceeds maximum" do
      it "is invalid" do
        user = build(:user, name: "a" * 51)
        expect(user).not_to be_valid
      end
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(user: 0, admin: 1).with_prefix(:role) }
  end

  describe "callbacks" do
    context "before_save downcase_email" do
      it "saves email in lowercase" do
        user = create(:user, email: "UPPER@Example.com")
        expect(user.email).to eq("upper@example.com")
      end
    end

    context "before_create create_activation_digest" do
      it "generates activation_token and digest" do
        user = create(:user)
        expect(user.activation_digest).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".recent" do
      it "orders users by created_at desc" do
        older = create(:user, created_at: 1.day.ago)
        newer = create(:user, created_at: Time.zone.now)
        expect(User.recent).to eq([newer, older])
      end
    end

    describe ".with_total_created_bookings" do
      it "returns users with total_created_bookings attribute" do
        user = create(:user)
        create(:booking, user: user, status: :pending)
        result = User.with_total_created_bookings.find(user.id)
        expect(result.total_created_bookings).to eq(1)
      end
    end
  end

  describe "class methods" do
    describe ".digest" do
      it "returns a BCrypt digest" do
        digest = User.digest("password")
        expect(BCrypt::Password.new(digest).is_password?("password")).to be true
      end
    end

    describe ".new_token" do
      it "returns a random token" do
        token = User.new_token
        expect(token).to be_present
      end
    end
  end

  describe "instance methods" do
    let(:user) { create(:user) }

    describe "#remember" do
      it "sets remember_digest" do
        user.remember
        expect(user.remember_digest).to be_present
      end
    end

    describe "#forget" do
      it "clears remember_digest" do
        user.remember
        user.forget
        expect(user.remember_digest).to be_nil
      end
    end

    describe "#authenticated?" do
      context "when digest is nil" do
        it "returns false" do
          expect(user.authenticated?(:remember, "token")).to be false
        end
      end

      context "when digest exists" do
        it "returns true for correct token" do
          user.remember
          expect(user.authenticated?(:remember, user.remember_token)).to be true
        end
      end
    end

    describe "#activate" do
      it "sets activated to true" do
        user.activate
        expect(user.activated).to be true
      end
    end

    describe "#status" do
      context "when not activated" do
        it "returns :unactive" do
          user = create(:user, activated: false)
          expect(user.status).to eq(:unactive)
        end
      end

      context "when activated" do
        it "returns :active" do
          user = create(:user, activated: true)
          expect(user.status).to eq(:active)
        end
      end
    end

    describe "#total_bookings" do
      it "returns count of bookings" do
        create_list(:booking, 2, user: user)
        expect(user.total_bookings).to eq(2)
      end
    end

    describe "#total_created_bookings" do
      it "counts bookings not in draft" do
        create(:booking, user: user, status: :pending)
        expect(user.total_created_bookings).to eq(1)
      end
    end

    describe "#total_successful_bookings" do
      it "counts confirmed and completed bookings" do
        create(:booking, user: user, status: :confirmed)
        expect(user.total_successful_bookings).to eq(1)
      end
    end

    describe "#total_cancelled_bookings" do
      it "counts cancelled bookings" do
        create(:booking, user: user, status: :cancelled)
        expect(user.total_cancelled_bookings).to eq(1)
      end
    end

    describe "#total_pending_bookings" do
      it "counts pending bookings" do
        create(:booking, user: user, status: :pending)
        expect(user.total_pending_bookings).to eq(1)
      end
    end

    describe "#create_reset_digest" do
      it "sets reset_digest and reset_sent_at" do
        user.create_reset_digest
        expect(user.reset_digest).to be_present
      end
    end

    describe "#password_reset_expired?" do
      context "when reset_sent_at is older than 2 hours" do
        it "returns true" do
          user.update(reset_sent_at: 3.hours.ago)
          expect(user.password_reset_expired?).to be true
        end
      end

      context "when reset_sent_at is within 2 hours" do
        it "returns false" do
          user.update(reset_sent_at: 1.hour.ago)
          expect(user.password_reset_expired?).to be false
        end
      end
    end
  end
end
