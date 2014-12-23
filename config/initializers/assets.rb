# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w(jquery-1.5.2.min.js jquery-1.4.2.min.js facebox.js facebox.css endless_page.js)
Rails.application.config.assets.precompile += %w( jquery.validate.min.js validation.js jquery.ui.core.css jquery.ui.theme.css jquery.ui.datepicker.css)
Rails.application.config.assets.precompile += %w( bookreviews.css perfect-scrollbar.css jquery.ui.core.js jquery.ui.datepicker.js)
Rails.application.config.assets.precompile += %w( font-awesome.css jquery.validate.min_1.8.1.js stylesheet-image-based.css)
Rails.application.config.assets.precompile += %w( jquery.fancybox.pack.js perfect-scrollbar.js )
Rails.application.config.assets.precompile += %w( jquery.fancybox.css style.css components.css typer.js )
Rails.application.config.assets.precompile += %w( admin_validation.js scroll.css)
Rails.application.config.assets.precompile += %w( ddaccordion.js jquery.mCustomScrollbar.css)
Rails.application.config.assets.precompile += %w( jquery.min.js jquery.mCustomScrollbar.concat.min.js)
Rails.application.config.assets.precompile += %w( bootstrap.min.css bootstrap.min.js)
Rails.application.config.assets.precompile += %w( component.css horizontalMenu.js)
Rails.application.config.assets.precompile += %w( cbpHorizontalMenu.min.js checkout.js)
Rails.application.config.assets.precompile += %w( jquery-1.7.0.min.js animated_message.js)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
