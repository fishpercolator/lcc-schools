module SchoolsHelper
  def feature_json(school)
    RGeo::GeoJSON.encode(RGeo::GeoJSON::EntityFactory.instance.feature(
                           school.centroid,
                           nil,
                           {
                             code: school.code,
                             name:  school.name,
                             address: school.address,
                             number_of_pupils: school.number_of_pupils,
                             available_places: school.available_places,
                             number_of_admissions: school.number_of_admissions,
                             nearest: school.nearest,
                             non_nearest: school.non_nearest,
                             own_admission_policy: school.own_admission_policy?
                           }
                         ))
  end

  def home_json(home_lonlat)
    RGeo::GeoJSON.encode(RGeo::GeoJSON::EntityFactory.instance.feature(home_lonlat, nil)).to_json.html_safe
  end
end
