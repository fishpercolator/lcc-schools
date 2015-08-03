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

  ##
  #
  # Makes a bootstrap button as a filter link
  #
  # @param options specify +options[:glyphs]+ with an array of glyph names to apply to the button
  # @return
  #   markup for a bootstrap button representing a filter, which will be a link
  #   if the filter is not already selected, and an active (unclickable) button otherwise
  def school_filter_link(text, name, value, options = {})
    raise ArgumentError, 'name must be a symbol' unless name.is_a?(Symbol)

    glyphs = Array(options[:glyphs])

    markup = if glyphs.try(:any?)
               glyphs.map do |glyph|
                 content_tag :span, nil, class: "image-glyph #{glyph}"
               end.join("\n")
             else
               ''
             end
    markup = (markup + content_tag(:span, text, class: 'filter-text')).html_safe

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
      content_tag(:a, markup, class: 'btn btn-default',
                  href: schools_path(current_scopes.merge({name => value})))
    end

  end

  ##
  # Return a Bootstrap badge indicating contention at the school
  def contention_badge(school, options = {})
    case
    when school.not_all_nearest
      content_tag :span, 'Not all nearest allocated', class: "badge badge-contention-high #{options[:class]}"
    when school.contended?
      content_tag :span, 'Oversubscribed',            class: "badge badge-contention-medium #{options[:class]}"
    when school.own_admission_policy?
      content_tag :span, 'Unknown',                   class: "badge badge-contention-unknown #{options[:class]}"
    else
      content_tag :span, 'Availability',              class: "badge badge-contention-low #{options[:class]}"
    end
  end

  # e.g. long_priority(:priority1a) => 'Priority 1a'
  def long_priority(sym)
    sym.to_s.humanize.sub(/([1-5])/, ' \1')
  end

  # e.g. short_priority(:priority1a) => '1a'
  def short_priority(sym)
    long_priority(sym).split(' ').last
  end

  # Help for the given priority, from locales/*.yml
  def tooltip_priority(sym)
    I18n.t("priority_popup_help.#{sym}")
  end

  ##
  # For a given school and priority attribute, return a string percentage
  # for use in styling the graph. Return 1% if the resulting value is 0%
  # (to yield an tiny-height line)
  #
  # e.g. priority_height_percent(school, :priority1a) => '14%'
  # @param school The school to use
  # @param attr The priority attribute for which to calculate the height
  def priority_height_percent(school, attr)
    return '0%' if school.sum_of_priorities.nil?

    max_in_priority = School.priorities.map { |sym| school.send(sym) || 0 }.max
    attr_value = school.send(attr) || 0

    percent = number_to_percentage((attr_value.to_f / max_in_priority) * 100, precision: 0)

    percent == '0%' ? '1%' : percent
  end

  def fa_priority_class(attr)
    { :priority1a => 'users',
      :priority1b => 'medkit',
      :priority2  => 'user-plus',
      :priority3  => 'link',
      :priority4  => 'home',
      :priority5  => 'arrows' }[attr] + ' inverse'
  end
end
