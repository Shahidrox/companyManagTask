# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :company
  has_one :user_group, dependent: :destroy
  accepts_nested_attributes_for :user_group
  has_one :group, through: :user_group

  validates :email, format: { with: /@/ }
  validate :age_check

  def age_check
    errors.add(:age, I18n.t('messages.greaterthan', resource: 'Age', value: '18')) if age.to_i < 18
  end
end
