require 'uk_postcode'

class Address < ActiveRecord::Base
  geocoded_by :geocoding_info

  validates :latitude, :longitude, presence: true
  validates :postcode,             presence: true, postcode: true
  validates :name_or_number,       presence: true

  def geocoding_info
    "#{name_or_number}, #{postcode}"
  end

  def to_s
    geocoding_info
  end

  def postcode=(value)
    write_attribute(:postcode, UKPostcode.parse(value).to_s)
  end

  def self.lookup(postcode, name_or_number)
    Address.where(
      postcode: postcode,
      name_or_number: name_or_number).first_or_initialize.tap do |address|

      if address.new_record?
        address.geocode if UKPostcode.parse(address.postcode).full_valid?
        address.save
      end
    end
  end
end
