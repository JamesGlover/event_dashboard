# frozen_string_literal: true
class Dashboard < ActiveRecord::Base

  extend DictionarySuggest::Suggestable

  suggests_with :key

  # Passwords are optional
  has_secure_password validations: false

  has_many :product_lines, dependent: :destroy, inverse_of: :dashboard, autosave: true

  validates_presence_of :name, :key
  validates_uniqueness_of :name, :key
  validates_format_of :key, with: /\A[\w_]{1,20}\z/

  scope :include_configuration, -> { includes(:product_lines=>[{ :product_line_event_types => :event_type },:subject_type,:role_type]) }

  # Rails 4 adds to_param class method, but this still appends the
  # id to the beginning.
  def to_param
    key
  end

  module KeyBehaviour
    def name=(name)
      self.key= name if name.present?
      super
    end

    def key=(string)
      scrubbed = string.downcase.gsub(/[^\w]+/,'_').truncate(20,omission:'')
      super(scrubbed)
    end
  end

  module PasswordBehaviour
    def password_protected?
      password_digest?
    end
  end

  include KeyBehaviour
  include PasswordBehaviour

end
