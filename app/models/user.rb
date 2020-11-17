class User < ApplicationRecord
  validates :email, email: true, presence: true
  validates :phone, phone: true, presence: true
  validates :first, presence: true, if: Proc.new { |u| !u.last.blank? }

  before_save :format_phone

  private

  def format_phone
    if self.phone
      p = Phonelib.parse(self.phone)
      self.phone = p.national
    end
  end
end
