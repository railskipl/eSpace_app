module MessagesHelper

	def post_user_id
		User.find(params[:user_id]).email
	end
end
