# frozen_string_literal: true

class Company < ApplicationRecord
	has_many :groups, dependent: :destroy
	has_many :users, dependent: :destroy

	validates :code, format: {
		with: /\A(?=.*\d)(?=.*[A-Za-z'-])[A-Za-z0-9'-]{1,50}\z/
	}
end
