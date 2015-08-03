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

  def long_priority(sym)
    sym.to_s.humanize.sub(/([1-5])/, ' \1')
  end

  def tooltip_priority(sym)
    case sym
    when :priority1a then 'Children in public care or fostered by arrangement'
    when :priority1b then 'Special or exceptional educational or medical needs that can only be met at a specific school'
    when :priority2 then 'Siblings at same school and same address'
    when :priority3 then 'Child already attending a linked school'
    when :priority4 then 'Nearest school'
    when :priority5 then 'All others choosing a Leeds school not their nearest, in decreasing order of distance'
    end
  end

  def short_priority(sym)
    long_priority(sym).split(' ').last
  end

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
