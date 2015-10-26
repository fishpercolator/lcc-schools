class Address < ActiveRecord::Base
  geocoded_by :geocoding_info

  validates_presence_of :latitude, :longitude

  def geocoding_info
    "#{name_or_number}, #{postcode}"
  end

  def to_s
    geocoding_info
  end

  def self.lookup(postcode, name_or_number)
    Address.where(
      postcode: postcode,
      name_or_number: name_or_number).first_or_initialize.tap do |address|

      if address.new_record?
        address.geocode
        address.save!
      end
    end
  end
end
