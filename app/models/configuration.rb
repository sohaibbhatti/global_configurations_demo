class Configuration < ActiveRecord::Base

  def self.save(key, value)
    Configuration.new(key: key, value: value).save!
    value
  end
end
