# spec/models/ability_spec.rb
require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  let(:room) { create(:room) }
  let(:amenity) { create(:amenity) }
  let(:room_type) { create(:room_type) }
  let(:room_availability) { create(:room_availability, room: room) }
  let(:other_user) { create(:user) }
  let(:booking) { create(:booking, user: user) }
  let(:other_booking) { create(:booking, user: other_user) }
  let(:request) { create(:request, booking: booking) }
  let(:other_request) { create(:request, booking: other_booking) }
  let(:review) { create(:review, request: request) }
  let(:other_review) { create(:review, request: other_request) }

  context "when user is an admin" do
    let(:user) { create(:user, role: :admin) }

    it "can manage rooms" do
      expect(ability).to be_able_to(:manage, room)
    end

    it "can manage amenities" do
      expect(ability).to be_able_to(:manage, amenity)
    end

    it "can manage bookings" do
      expect(ability).to be_able_to(:manage, booking)
    end

    it "can manage reviews" do
      expect(ability).to be_able_to(:manage, review)
    end
  end

  context "when user is a regular logged-in user" do
    let(:user) { create(:user, role: :user) }

    it "can read rooms" do
      expect(ability).to be_able_to(:read, room)
    end

    it "can read amenities" do
      expect(ability).to be_able_to(:read, amenity)
    end

    it "can read room types" do
      expect(ability).to be_able_to(:read, room_type)
    end

    # it "can read room availabilities" do
    #   expect(ability).to be_able_to(:read, room_availability)
    # end

    it "can read own user record" do
      expect(ability).to be_able_to(:read, user)
    end

    it "can update own user record" do
      expect(ability).to be_able_to(:update, user)
    end

    it "cannot update other user record" do
      expect(ability).not_to be_able_to(:update, other_user)
    end

    it "can create bookings" do
      expect(ability).to be_able_to(:create, Booking.new(user: user))
    end

    it "can read own bookings" do
      expect(ability).to be_able_to(:read, booking)
    end

    it "can update own bookings" do
      expect(ability).to be_able_to(:update, booking)
    end

    it "cannot update others' bookings" do
      expect(ability).not_to be_able_to(:update, other_booking)
    end

    it "can create requests" do
      expect(ability).to be_able_to(:create, Request.new(booking: booking))
    end

    it "can read own requests" do
      expect(ability).to be_able_to(:read, request)
    end

    it "can update own requests" do
      expect(ability).to be_able_to(:update, request)
    end

    it "cannot update others' requests" do
      expect(ability).not_to be_able_to(:update, other_request)
    end

    it "can create reviews" do
      expect(ability).to be_able_to(:create, Review.new(request: request))
    end

    it "can read own reviews" do
      expect(ability).to be_able_to(:read, review)
    end

    it "can update own reviews" do
      expect(ability).to be_able_to(:update, review)
    end

    it "cannot update others' reviews" do
      expect(ability).not_to be_able_to(:update, other_review)
    end
  end

  context "when user is a guest" do
    let(:user) { nil }

    it "can read rooms" do
      expect(ability).to be_able_to(:read, room)
    end

    it "can read amenities" do
      expect(ability).to be_able_to(:read, amenity)
    end

    it "can read room types" do
      expect(ability).to be_able_to(:read, room_type)
    end

    # it "can read room availabilities" do
    #   expect(ability).to be_able_to(:read, room_availability)
    # end

    it "cannot update users" do
      expect(ability).not_to be_able_to(:update, User.new)
    end

    it "cannot create bookings" do
      expect(ability).not_to be_able_to(:create, Booking.new)
    end

    it "cannot update requests" do
      expect(ability).not_to be_able_to(:update, Request.new)
    end

    it "cannot update reviews" do
      expect(ability).not_to be_able_to(:update, Review.new)
    end
  end
end
