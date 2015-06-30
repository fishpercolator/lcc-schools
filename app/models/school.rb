class School < ActiveRecord::Base
  # Hard-coded. Nearest to an old garden centre in Red Hall.
  scope :nearest, -> {
    select("schools.*, ST_Distance(schools.centroid,'SRID=4326;POINT(-1.4715568 53.840504)'::geometry)").
    order("schools.centroid <->'SRID=4326;POINT(-1.4715568 53.840504)'::geometry")
  }

  def address
    "#{address1} #{postcode}"
  end
end
