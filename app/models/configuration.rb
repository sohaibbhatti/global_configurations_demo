class Configuration < ActiveRecord::Base

  def self.save(key, value)
    Configuration.new(key: key, value: value).save!
    value
  end

  def self.read(key)
    if configuration = Configuration.find_by_key(key)
      configuration.value
    else
      raise ActiveRecord::RecordNotFound
    end

  end
end
