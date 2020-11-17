require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'validates email' do
      expect(build(:user, email: 'notvalid')).to_not be_valid
    end
    context 'phone' do
      it 'validates phone number has enough digits' do
        expect(build(:user, phone: '123456')).to_not be_valid
      end

      it 'validates phone number to not have 0 in the first position' do
        expect(build(:user, phone: '0123456789')).to_not be_valid
      end

      it 'validates phone number to not have 0 in the fourth position' do
        expect(build(:user, phone: '2230567890')).to_not be_valid
      end

      it 'allows the number to have dots' do
        expect(build(:user, phone: '214.323.6666')).to be_valid
      end

      it 'allows the number to have dashes' do
        expect(build(:user, phone: '214-323-6666')).to be_valid
      end

      it 'allows the number to have spaces' do
        expect(build(:user, phone: '214 323 6666')).to be_valid
      end

      it 'does not allow longer numbers' do
        expect(build(:user, phone: '44-234-567-9999')).to_not be_valid
      end
    end

    it 'requires email' do
      expect(build(:user, email: nil)).to_not be_valid
    end

    it 'requires phone' do
      expect(build(:user, phone: nil)).to_not be_valid
    end

    it 'does not require first and last' do
      expect(build(:user, first: nil, last: nil)).to be_valid
    end

    it 'requires first if last is present' do
      expect(build(:user, first: nil, last: 'here')).to_not be_valid
    end
    
  end

  it 'persists the phone number in the right format' do
    u = create(:user, phone: '817.282.5660')
    expect(u.reload.phone).to eq('(817) 282-5660')
  end

end
