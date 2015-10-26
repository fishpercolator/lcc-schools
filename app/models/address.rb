class Address < ActiveRecord::Base
  geocoded_by :geocoding_info

  def geocoding_info
    "#{name_or_number}, #{postcode}"
  end
end
