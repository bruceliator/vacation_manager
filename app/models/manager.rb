class Manager < ApplicationRecord
  include HasVacation

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
