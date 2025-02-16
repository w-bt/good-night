# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Redis::User do
  let(:user) { create(:user) }
  let(:redis_key) { "User::#{user.id}" }
  let(:redis_user) { described_class.new(user.id) }

  before do
    allow(REDIS).to receive(:get).and_call_original
    allow(REDIS).to receive(:set).and_call_original
    allow(REDIS).to receive(:del).and_call_original
  end

  describe "#get" do
    context "when user is cached in Redis" do
      before do
        REDIS.set(redis_key, user.to_json)
      end

      it "returns the user from Redis" do
        cached_user = redis_user.get

        expect(cached_user).to be_a(User)
        expect(cached_user.id).to eq(user.id)
        expect(cached_user.name).to eq(user.name) # Assuming user has a name attribute
        expect(REDIS).to have_received(:get).with(redis_key)
      end
    end

    context "when user is NOT cached in Redis" do
      before do
        REDIS.del(redis_key) # Ensure cache is empty
      end

      it "fetches user from database and caches it in Redis" do
        expect(User).to receive(:where).and_return([ user ])

        fetched_user = redis_user.get

        expect(fetched_user).to be_a(User)
        expect(fetched_user.id).to eq(user.id)
        expect(REDIS).to have_received(:set).with(redis_key, user.to_json, nx: true, ex: 1.day)
      end
    end

    context "when user does not exist in database" do
      before do
        redis_user.del
        allow(User).to receive(:where).and_return(nil)
      end

      it "returns nil and does not cache anything" do
        fetched_user = redis_user.get

        expect(fetched_user).to be_nil
        expect(REDIS).not_to have_received(:set)
      end
    end
  end

  describe "#del" do
    before do
      REDIS.set(redis_key, user.to_json)
    end

    it "removes the user from Redis" do
      redis_user.del

      expect(REDIS).to have_received(:del).with(redis_key)
      expect(REDIS.get(redis_key)).to be_nil
    end
  end
end
