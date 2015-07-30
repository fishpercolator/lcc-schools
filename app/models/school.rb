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
    where("schools.phase ~* ? OR schools.phase ~* 'through'", [phase])
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

  def community_admission_policy?
    !own_admission_policy?
  end

  def own_admission_policy?
    !!(name =~ /voluntary/i)
  end

  def to_param
    code
  end

  def contended?
    nearest.present?
  end

  def priority_stats?
    priority_methods.any? { |priority| (send priority).present? }
  end

  def sum_of_priorities
    return nil unless priority_stats?
    priority_methods.inject(0) do |sum, prop|
      value = send prop
      sum += value if value
      sum
    end
  end

  def age_range
    "#{from_age}-#{to_age}"
  end
private
  def priority_methods
    %i( priority1a priority1b priority2
         priority3 priority4 priority5  )
  end
end
