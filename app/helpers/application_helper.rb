module ApplicationHelper
def format_boolean(status)
	 if status
	 icon_tick
	 else
	 icon_cross
	 end
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
end
