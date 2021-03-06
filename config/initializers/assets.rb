# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w(jquery-1.5.2.min.js jquery-1.4.2.min.js facebox.js facebox.css endless_page.js)
Rails.application.config.assets.precompile += %w( jquery.validate.min.js validation.js jquery.ui.core.css jquery.ui.theme.css jquery.ui.datepicker.css)
Rails.application.config.assets.precompile += %w( bookreviews.css perfect-scrollbar.css jquery.ui.core.js jquery.ui.datepicker.js)
Rails.application.config.assets.precompile += %w( font-awesome.css jquery.validate.min_1.8.1.js stylesheet-image-based.css)
Rails.application.config.assets.precompile += %w( jquery.fancybox.pack.js perfect-scrollbar.js overview.css)
Rails.application.config.assets.precompile += %w( jquery.fancybox.css style.css components.css typer.js select_date.js)
Rails.application.config.assets.precompile += %w( admin_validation.js scroll.css datepicker_post.js area_needed.js post_on_map.js)
Rails.application.config.assets.precompile += %w( ddaccordion.js jquery.mCustomScrollbar.css create_post.js select_admin_date.js)
Rails.application.config.assets.precompile += %w( jquery.min.js jquery.mCustomScrollbar.concat.min.js stripe_validation.js)
Rails.application.config.assets.precompile += %w( bootstrap.min.css bootstrap.min.js refresh_count.js order_receive.css)
Rails.application.config.assets.precompile += %w( component.css horizontalMenu.js pdf_invoice.css bookings.css booking_popup.css)
Rails.application.config.assets.precompile += %w( cbpHorizontalMenu.min.js checkout.js scrollbar.js compose_message.css)
Rails.application.config.assets.precompile += %w( jquery-1.7.0.min.js animated_message.js active_textarea.js dropoff_and_pickup_date.js datepickervalidation.js)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
