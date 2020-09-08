class User < ApplicationRecord
  DEFAULT_NAME = "#{Rails.application.class.module_parent} User".freeze

  before_validation :set_defaults

  def token
    TokenService.encode('user' => id)
  end

  def index_hash
    h = standard_hash
    # Add new attributes here as shown below:
    # h[:images] = images
    return h
  end

  def show_hash
    h = standard_hash
    # Add new attributes here as shown below:
    # h[:images] = images
    return h
  end

  def standard_hash
    {
      id: id,
      name: name,
      city: city,
      wechat: wechat,
      phone: phone,
      email: email,
      gender: gender,
      admin: admin
    }
  end

  private

  def set_defaults
    self.name = DEFAULT_NAME if self.name.blank?
  end
end
