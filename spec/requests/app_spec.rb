require 'rails_helper'

RSpec.describe Api::V1::CompaniesController do

  describe "Company" do
    before do
      post :create, params: {company: {name: Faker::Name.name, code: "testCode0-1"}}
      @resp = JSON.parse(response.body)
    end

    it "invalid company code" do
      post :create, params: {company: {name: Faker::Name.name, code: "testCode"}}
      expect(response.status).to eq(400)
      resp = JSON.parse(response.body)
      expect(resp['errors']).to eq("Code is invalid")
    end

    it "duplicate company code" do
      post :create, params: {company: {name: Faker::Name.name, code: "testCode0-1"}}
      expect(response.status).to eq(400)
    end

    it "valid company code" do
      post :create, params: {company: {name: Faker::Name.name, code: "testCode0-2"}}
      resp = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(resp['notice']).to eq(I18n.t('messages.created', resource: 'Company'))
    end

    it "List of company" do
      get :index
      resp = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(resp['data'][0]).to eq(@resp['data'])
    end
  end

  describe "Group" do
    before do
      post :create, params: {company: {name: Faker::Name.name, code: "testCode0-1"}}
      @resp1 = JSON.parse(response.body)
      post :create, params: {company: {name: Faker::Name.name, code: "testCode0-2"}}
      @resp2 = JSON.parse(response.body)
    end

    it "create" do
    end

    it "duplicate" do
    end

    it "duplicate group for difrent company" do
    end

    it "update" do
    end

    it "list" do
    end
  end

  describe "Users" do
    it "Create" do
    end

    it "update" do
    end

    it "list" do
    end

    it "assign group" do
    end

    it "delete" do
    end
  end

  describe "user group assign" do
    it "group list" do
    end

    it "assign a group to user" do
    end
  end
end
