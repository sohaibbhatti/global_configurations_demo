class Configuration < ActiveRecord::Base
  before_save   :encode_value

  after_save    :write_to_cache
  after_destroy :delete_from_cache

  def self.save(key, value)
    Configuration.new(key: key, value: value).save!
    value
  end

  def self.read(key)
    value =  fetch_record(key)
    raise ActiveRecord::RecordNotFound if value.nil?

    ActiveSupport::JSON.decode value
  end

  def self.delete(key)
    if configuration = Configuration.find_by_key(key)
      configuration.destroy
      true
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def encode_value
    self.value = value.to_json
  end

  def write_to_cache
    Rails.cache.write cache_key, value
  end

  def delete_from_cache
    Rails.cache.delete cache_key
  end

  def self.fetch_record(key)
    Rails.cache.fetch(cache_key(key)) do
      config = Configuration.find_by_key(key)
      config.value if config
    end
  end

  def self.cache_key(key)
    "configuration::#{key}"
  end

  def cache_key
    self.class.cache_key key
  end
end
