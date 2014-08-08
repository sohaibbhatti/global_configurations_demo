class Configuration < ActiveRecord::Base
  before_save :encode_value

  def self.save(key, value)
    Configuration.new(key: key, value: value).save!
    value
  end

  def self.read(key)
    if configuration = Configuration.find_by_key(key)
      ActiveSupport::JSON.decode configuration.value
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def encode_value
    self.value = value.to_json
  end
end
