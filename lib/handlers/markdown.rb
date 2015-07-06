require 'kramdown'

module Handlers
  module Markdown
    def self.erb
      @erb ||= ActionView::Template.registered_template_handler(:erb)
    end

    def self.call(template)
      compiled_source = erb.call(template)
      "Kramdown::Document.new(begin;#{compiled_source};end, auto_ids: false, parse_block_html: true).to_html.html_safe"
    end
  end

  ActionView::Template.register_template_handler :md, Markdown
end
