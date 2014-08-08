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
      before { Configuration.save 'foo', 'already_exists' }

      it 'prevents overwriting or duplicate copies' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe '.read' do
    subject { Configuration.read 'foo' }

    context 'configuration does not exist' do
      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'configuration exists' do
      before { Configuration.save 'foo', 'already_exists' }
      it { is_expected.to eql 'already_exists' }
    end
  end

  describe 'Format Support' do
    it 'supports strings' do
      Configuration.save 'foo', 'bar'
      expect(Configuration.read 'foo').to eql 'bar'

      Configuration.save 'foo_new', ''
      expect(Configuration.read 'foo_new').to eql ''
    end

    it 'supports numbers' do
      Configuration.save 'foo', 123
      expect(Configuration.read 'foo').to eql 123
    end
  end
end
