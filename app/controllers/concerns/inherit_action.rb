# frozen_string_literal: true

module InheritAction
  extend ActiveSupport::Concern

	included do
    before_action :get_resource, only: %i[show update destroy]
  end

	def index
    @resources = resource_class.all
		render json: { data: @resources.as_json }, status: 200
  end

	def create
		@resource = resource_class.new(resource_params)
		if @resource.save
			render json: { data: @resource.as_json, notice: I18n.t('messages.created', resource: resource) }, status: 200
		else
			render json: { errors: @resource.errors.full_messages.to_sentence }, status: 400
		end
	end

	def update
		if @resource.update(resource_params)
			render json: { data: @resource.as_json }, status: 200
		else
			render json: { errors: @resource.errors.full_messages.to_sentence }, status: 400
		end
	end

	def destroy
		if @resource.destroy
			render json: { data: [], message: I18n.t('messages.destroyed', resource: resource) }, status: 200
		else
			render json: { errors: @resource.errors.full_messages.to_sentence }, status: 400
		end
	end
	
	def show
		render json: { data: @resource.as_json }, status: 200
	end

	private

	def resource
    resource_name.classify
  end

  def resource_class
    resource_name.classify.constantize
  end

	def resource_name
    controller_name.singularize
  end

	def resource_params
    params.require(resource_name.to_sym).permit(permitted_attributes)
  end

	def permitted_attributes
    resource_class.column_names
  end

	def get_resource
		begin
			@resource = resource_class.find(params[:id])
		rescue => e
			render json: { data: e }, status: 400
		end
  end
end