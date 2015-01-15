module ApplicationHelper
	def format_boolean(status)
		 if status
		 icon_tick
		 else
		 icon_cross
		 end
	end


   def link_to_add_fields(name, f, association)
       new_object = f.object.send(association).klass.new
       id = new_object.object_id
	   fields = f.fields_for(association, new_object, child_index: id) do |builder|
	    render(association.to_s.singularize + "_fields", f: builder)
	   end
       link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
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
	  css_class = column == sort_column ? "sort_active #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end

	# Custome dropdown
	def options_with_colors(values, sel_val)
	
	  values.collect do |sel| 
	  	if sel_val.to_i == sel
	    	"<option value='#{sel}' style='color:#999;' selected='selected ' >#{sel}</option> ".html_safe
	    else
	    	"<option value='#{sel}' style='color:#999;' >#{sel}</option> ".html_safe
	    end
	  end.join

	end

	  def resource_name
	    :user
	  end

	  def resource
	    @resource ||= User.new
	  end

	  def devise_mapping
	    @devise_mapping ||= Devise.mappings[:user]
	  end


end
