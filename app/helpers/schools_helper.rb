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

  def school_filter_link(text, name, value, options = {})
    # <a class="btn btn-default" href="<%= sites_path by_green_status: 'green' %>">
    #   <span class="glyphicon glyphicon-tree-deciduous"></span>
    #   Greenfield
    # </a>
    raise ArgumentError, 'name must be a symbol' unless name.is_a?(Symbol)

    markup = content_tag(:span, text, class: 'filter-text')

    case
    when current_scopes[name] == value
      # Value is already selected. Don't render a link
      content_tag(:span, markup, class: 'btn btn-default active')
    when value == :all
      # Value should be removed from the query string
      content_tag(:a, markup, class: "btn btn-default#{" active" if current_scopes[name].nil? }",
                  href: schools_path(current_scopes.except(name)))
    else
      # Value should be added to the query string
      content_tag(:a, markup, class: options[:class] || 'btn btn-default',
                  href: schools_path(current_scopes.merge({name => value})))
    end

  end

  def contention_for(school)
    case
    when school.not_all_nearest
      content_tag :span, 'Not all nearest allocated', class: 'badge badge-contention-high'
    when school.contended?
      content_tag :span, 'Oversubscribed',            class: 'badge badge-contention-medium'
    else
      content_tag :span, 'Availability',              class: 'badge badge-contention-low'
    end
  end
end
