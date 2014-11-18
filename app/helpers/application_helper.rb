module ApplicationHelper
def format_boolean(status)
	 if status
	 icon_tick
	 else
	 icon_cross
	 end
end

 def yes_no(featured)
    featured ? "Active" : "Inactive"
 end

def icon_tick(alt_text='Tick')
	build_image_tag("deactivate.png", alt_text)
end

def icon_cross(alt_text='Cross')
	build_image_tag("activate.png", alt_text)
end

def build_image_tag(image_file, alt_text)
	image_tag(image_file, :alt => alt_text)
end

def sortable(column, title = nil)
  title ||= column.titleize
  css_class = column == sort_column ? "current #{sort_direction}" : nil
  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
end


end
