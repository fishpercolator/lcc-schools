class SchoolsController < ApplicationController
  def apply
  end

  def home_point
    [-1.4715568, 53.840504]
  end

  def results
    @home = RGeo::Geographic.spherical_factory.point(*home_point)
    community_schools = School.community.where(phase: 'Primary').nearest_to(@home).limit(5)
    own_admission_policy_schools =
      School.own_admissions_policy.where(phase: 'Primary').nearest_to(@home).limit(5)

    @schools = community_schools + own_admission_policy_schools

    respond_to do |format|
      format.html    { render }
      format.geojson { render geojson: @schools }
    end
  end

  def index
    @schools = School.all

    respond_to do |format|
      format.html    { render }
      format.geojson { render geojson: @schools }
    end
  end
end
