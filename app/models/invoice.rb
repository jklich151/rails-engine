class Invoice < ApplicationRecord
  validates_presence_of :status

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  belongs_to :customer
  belongs_to :merchant
end
