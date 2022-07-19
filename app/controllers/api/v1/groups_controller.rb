# frozen_string_literal: true

class Api::V1::GroupsController < ApplicationController
  include InheritAction
  before_action :get_company, only: %i[create]
  before_action :set_page, only: [:group_list]

  include Pagination
  DEFAULT_PAGE = 1
  DEFAULT_PAGE_SIZE = 5

  def index
    @resources = Company.select("groups.id, groups.name, companies.id company_id, companies.code company_code, companies.name company_name").joins(:groups)
    render json: { data: @resources.as_json }, status: 200
  end

  def create
    if @company.present?
      group = @company.groups.build(resource_params)
      if group.save
        render json: { data: group.as_json, notice: I18n.t('messages.created', resource: 'Group') }, status: 200
      else
        render json: { errors: group.errors.full_messages.to_sentence }, status: 400
      end
    else
      render json: { errors: I18n.t('messages.not_fount', resource: 'Company') }, status: 400
    end
  end

  def group_list
    list = Group.
      select('groups.id, groups.name, companies.code').
      joins(:company).
      left_joins(:user_groups).
      group('groups.id, companies.code, groups.name, user_groups.group_id').
      order('groups.id').
      page(@page).
      per(@size)
    pages  = pagination(list)
    render json: { data: list.as_json, pagination: pages}, status: 200
  end

  private

  def set_page
    @page = params[:page].present? ? params[:page].to_i : DEFAULT_PAGE
    @size = params[:size].present? ? params[:size].to_i : DEFAULT_PAGE_SIZE
  end

  def get_company
    begin
			@company = Company.find(params[:group][:company_id])
		rescue => e
			render json: { data: e }, status: 400
		end
  end

  def resource_params
    params.require(:group).permit(:name, :company_id)
  end
end
