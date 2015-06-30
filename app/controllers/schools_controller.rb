class SchoolsController < ApplicationController
  def apply

  end

  def results
    @schools = School.where(phase: 'Primary').nearest.limit(5)

    respond_to do |format|
      format.html do
        render
      end
      format.geojson do
        render geojson: @schools
      end
    end
  end
end
