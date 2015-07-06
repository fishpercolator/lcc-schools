class School < ActiveRecord::Base
  scope :nearest_to, -> (point) {
    select("schools.*, ST_Distance(schools.centroid,'SRID=4326;POINT(#{point.lon} #{point.lat})'::geometry) AS distance").
    order("schools.centroid <->'SRID=4326;POINT(#{point.lon} #{point.lat})'::geometry")
  }

  scope :community, -> {
    where("schools.name !~* 'voluntary'")
  }

  scope :own_admissions_policy, -> {
    where("schools.name ~* 'voluntary'")
  }

  def address
    "#{address1} #{postcode}"
  end

  def own_admission_policy?
    !!(name =~ /voluntary/i)
  end
end
