require 'spec_helper'

describe GroupsController do

  let(:user_session) { {user_id: user.id} }
  let(:admin_session) { {user_id: admin.id} }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:group) { FactoryGirl.create(:group) }

  describe "Access permissons" do
    describe "GET index" do
      it "allows guest users" do
        get :index, {}, {}
        expect(response.code).to eq "200"
      end
      it "allows standard users" do
        get :index, {}, user_session
        expect(response.code).to eq "200"
      end
      it "allows admin users" do
        get :index, {}, admin_session
        expect(response.code).to eq "200"
      end
    end
    describe "GET show" do
      it "allows guest users" do
        get :show, { id: group.id }, {}
        expect(response.code).to eq "200"
      end
      it "allows standard users" do
        get :show, { id: group.id }, user_session
        expect(response.code).to eq "200"
      end
      it "allows admin users" do
        get :show, { id: group.id }, admin_session
        expect(response.code).to eq "200"
      end
    end

    {new: :get, edit: :get, create: :post, update: :post, destroy: :delete}.each_pair do |action, verb|
      describe "#{verb.upcase} #{action}" do
        it "redirects guest users" do
          send(verb, action, { id: group.id, group: {name: "foobar"} }, {})
          expect(response.code).to eq "302"
        end
        it "forbids standard users" do
          send(verb, action, { id: group.id, group: {name: "foobar"} }, user_session)
          expect(response.code).to eq "403"
        end
        it "allows admin users" do
          send(verb, action, { id: group.id, group: {name: "foobar"} }, admin_session)
          expect(response.code).to_not eq "403"
        end
      end
    end
  end
end
