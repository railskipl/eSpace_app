class CustomFailure < Devise::FailureApp
  def redirect_url
	if warden_options[:scope] == :user
	  root_path
	else
	  super
	end
  end

  def respond
  	if  http_auth?
  	  redirect_to user_session_path(:flash => i18n_message)
	else
	  redirect
	end
  end

end