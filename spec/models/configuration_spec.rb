require 'rails_helper'

RSpec.describe Configuration, :type => :model do
  describe '.save' do
    subject { Configuration.save 'foo', 'bar' }

    context 'configuration does not exist' do
      it 'saves the configuration' do
        expect { subject }.to change { Configuration.count }.by 1
      end

      it { is_expected.to eql 'bar' }
    end

    context 'configuration exists' do
      before { Configuration.save 'foo', 'already_exist' }

      it 'prevents overwriting or duplicate copies' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end

    end
  end
end
