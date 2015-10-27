class SchoolsController < ApplicationController
  has_scope :community
  has_scope :voluntary
  has_scope :admissions_policy do |_, scope, value|
    case value.to_sym
    when :community then scope.community
    when :own_admissions_policy then scope.own_admissions_policy
    else scope
    end
  end

  has_scope :containing_text
  has_scope :phase

  def apply
    @address = Address.new
  end

  def compare
  end

  def results
    @address = Address.lookup(address_params[:postcode], address_params[:name_or_number])
    unless @address.valid?
      render 'apply' and return
    end

    @home = RGeo::Geographic.spherical_factory.point(@address.longitude, @address.latitude)

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
    @schools = apply_scopes(School).all

    respond_to do |format|
      format.html    { render }
      format.geojson { render geojson: @schools }
    end
  end

  def show
    @school = School.find_by!(code: params[:id])

    respond_to do |format|
      format.html    { render }
      format.geojson { render geojson: @school }
    end
  end

private
  def address_params
    params.require(:address).permit(:postcode, :name_or_number)
  end
end
