class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :records

  after_create :assign_default_role

  def user?
    has_role? :user
  end

  def admin?
    has_role? :admin
  end

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
