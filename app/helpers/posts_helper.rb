module PostsHelper

require 'open-uri'

 # def current_user_token(user)
 #    @user_fb_token = current_user.oauth_token
 #    @users = User.find_by_id(user)
 #    @users.oauth_token
 # end

  # This method send the request to facebookGraph Api & gives the mutual friend count.
  def mutual_friend_list(user_id)

      users = User.find_by_id(user_id)

      file_location = "https://graph.facebook.com/v2.2/#{users.uid}?fields=context.fields%28mutual_friends%29&access_token=#{current_user.oauth_token}"

      @response = RestClient.get(file_location){ |response, request, result, &block|
                    case response.code
                    when 200
                       mutual_friend_list = response
                       mutual = ActiveSupport::JSON.decode(mutual_friend_list)
                       mcount = mutual["context"]["mutual_friends"]["data"]

                       mutual_count = mcount.count
                       return mutual_count
                    else
                       response
                    end
                  }
  end

  def date_range(post)
    if post.drop_off_avaibility_start_date >= Date.today
       post.drop_off_avaibility_start_date.strftime("%B %d, %Y")
    else
       Date.today.strftime("%B %d, %Y")
    end
  end

 def processing_fees(fees)
   if fees <= GlobalConstants::BOOKING_AMOUNT
   	@cut_off = fees.to_f * GlobalConstants::ADMIN_COMISSION
   	return @cut_off
   elsif fees > GlobalConstants::BOOKING_AMOUNT
     @cut_off = fees.to_f * 10/100
     return @cut_off
   end
 end

end
