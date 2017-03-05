class Worker < ApplicationRecord
  include HasVacation
  validates_presence_of :email
end
