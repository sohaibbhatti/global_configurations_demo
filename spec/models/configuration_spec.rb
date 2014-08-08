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

  def save_and_validate(key, value)
    Configuration.save key, value
    expect(Configuration.read key).to eql value
  end

  describe 'Format Support' do
    it 'supports strings' do
      save_and_validate 'foo', 'bar'
      save_and_validate 'foo_new', ''
    end

    it 'supports numbers' do
      save_and_validate 'foo', 123
      save_and_validate 'foo_new', 123.456
    end

    it 'supports booleans' do
      save_and_validate 'foo', true
      save_and_validate 'foo_new', false
    end

    it 'supports null' do
      save_and_validate 'foo', nil
    end
  end
end
