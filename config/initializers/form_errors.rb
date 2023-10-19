# frozen_string_literal: true

# Place this code in a initializer.
# E.g: config/initializers/form_errors.rb
ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')
  method_name = instance_tag.instance_variable_get('@method_name').humanize
  html = if field
           field['class'] = "#{field['class']} border-red-500 border"
           html = <<-HTML
                #{fragment&.to_s}
                <p class="text-red-500 text-xs italic mt-1">#{method_name} #{instance_tag&.error_message&.first}</p>
           HTML
           html
         else
           html_tag
         end
  html.html_safe
end
