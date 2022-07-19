# frozen_string_literal: true

class Api::V1::CompaniesController < ApplicationController
  include InheritAction

  def resource_params
    params.require(:company).permit(:code, :name)
  end
end
