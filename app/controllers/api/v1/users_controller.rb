# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  include InheritAction
  before_action :get_company, only: %i[create]
  before_action :get_user, only: %i[assign_group]

  def index
    @resources = User.select("users.id, companies.code company_code, companies.name company_name, groups.name group_name, users.email, users.first_name, users.last_name, users.age").joins(:company).left_joins(:group)
    render json: { data: @resources.as_json }, status: 200
  end

  def create
    if @company.present?
      user = @company.users.build(resource_params)
      if user.save
        render json: { data: user.as_json, notice: I18n.t('messages.created', resource: 'User') }, status: 200
      else
        render json: { errors: user.errors.full_messages.to_sentence }, status: 400
      end
    else
      render json: { errors: I18n.t('messages.not_fount', resource: 'User') }, status: 400
    end
  end

  def assign_group
    render json: { errors: 'Bad Request' }, status: 400 if params[:user_id].blank? || params[:user_id].blank?

    if @user.user_group.present?
      render json: { errors: I18n.t('messages.already_added', resource: 'Group') }, status: 400
    else
      company = @user.company&.groups&.where(id: params[:group_id])
      if company.present?
        group = @user.build_user_group(group_id: params[:group_id])
        if group.save
          render json: { data: @user.user_group.as_json, notice: I18n.t('messages.created', resource: 'UserGroup') }, status: 200
        else
          render json: { errors: group.errors.full_messages.to_sentence }, status: 400
        end
      else
        render json: { errors: I18n.t('messages.not_fount', resource: "User company's group") }, status: 400
      end
    end
  end

  private

  def get_company
    begin
			@company = Company.find(params[:user][:company_id])
		rescue => e
			render json: { data: e }, status: 400
		end
  end

  def get_user
    @user = User.find(params[:user_id])
  end

  def resource_params
    params.
    require(:user).
    permit(
      :email,
      :first_name,
      :last_name,
      :age,
      user_group_attributes: [
        :id,
        :user_id,
        :group_id
      ]
    )
  end
end
