class SchoolsController < ApplicationController
  def apply
  end

  def home_point
    [-1.4715568, 53.840504]
  end

  def results
    @home = RGeo::Geographic.spherical_factory.point(*home_point)
    @schools = School.where(phase: 'Primary').nearest_to(@home).limit(5)

    respond_to do |format|
      format.html    { render }
      format.geojson { render geojson: @schools }
    end
  end
end
