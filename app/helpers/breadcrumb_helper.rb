module BreadcrumbHelper
  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(title, path = nil, active: false)
    breadcrumbs << {
      title: title,
      path: path,
      active: active
    }
  end

  def render_breadcrumbs
    return if breadcrumbs.empty?

    content_tag :nav, class: "bg-gray-100 border-b border-gray-200 px-4 py-2" do
      content_tag :div, class: "container mx-auto flex items-center space-x-2 text-sm" do
        breadcrumbs.map.with_index do |crumb, index|
          render_breadcrumb_item(crumb, index == breadcrumbs.length - 1)
        end.join.html_safe
      end
    end
  end

  private

  def render_breadcrumb_item(crumb, is_last)
    if is_last || crumb[:active]
      # Last item - no link, just text
      content_tag :span, crumb[:title], class: "text-gray-600 font-medium"
    else
      # Link item
      link_to crumb[:title], crumb[:path], class: "text-blue-600 hover:text-blue-800 hover:underline"
    end + (is_last ? "" : content_tag(:span, " / ", class: "text-gray-400 mx-2"))
  end
end
