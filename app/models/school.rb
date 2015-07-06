class School < ActiveRecord::Base
  include PgSearch
  pg_search_scope :containing_text, against: {
    code: 'A',
    name: 'A',
    address1: 'A',
    address2: 'A',
    address3: 'A',
    postcode: 'B'
  }

  scope :phase, -> (phase) {
    where("schools.phase ~* ?", [phase])
  }

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
