module ApplicationHelper
  def nav_link(active, name, options = {}, html_options = {}, &block)
    li_options = active ? { class: 'active' } : {}
    content_tag :li, li_options do
      link_to name, options, html_options, &block
    end
  end

end
