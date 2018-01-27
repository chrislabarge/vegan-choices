require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#user_authorize?" do
    let(:controller) { ApplicationController.new }
    let(:user) { double(:user) }

    it "authorizes current user if eq to passed user" do
      allow(controller).to receive(:current_user).and_return(user)

      actual = controller.user_authorized?(user)
      expect(actual).to eq true
    end

    it "authorizes current user if is current user is admin" do
      admin_user = double(:user, admin: true)
      allow(controller).to receive(:current_user).and_return(admin_user)

      actual = controller.user_authorized?(user)
      expect(actual).to eq true
    end

    it "does not authorize current user if current_user does not eq passed user and  is NOT admin" do
      another_user = double(:user, admin: false)
      allow(controller).to receive(:current_user).and_return(another_user)

      actual = controller.user_authorized?(user)
      expect(actual).to eq false
    end

    it "does not authorize vistor" do
      allow(controller).to receive(:current_user).and_return(nil)

      actual = controller.user_authorized?(user)
      expect(actual).to eq false
    end
  end
end
