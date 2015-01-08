module PostsHelper

 def current_user_token(user)
    @user_fb_token = current_user.oauth_token
    @users = User.find_by_id(user)
    @users.oauth_token 
 end

  # This method send the request to facebookGraph Api & gives the mutual friend count.  
  def mutual_friend_list(user_id)

      @users = User.find_by_id(user_id)
      @user_token = @users.oauth_token 
      
      file_location = "https://graph.facebook.com/v2.2/#{current_user.uid}?fields=context.fields%28mutual_friends%29&access_token=#{@user_token}"

      @response = RestClient.get(file_location){ |response, request, result, &block|
                    case response.code
                    when 200
                       @mutual_friend_list = response 
                       @mutual_friend_list = response 
                       @mutual = ActiveSupport::JSON.decode(@mutual_friend_list)
                       @count = @mutual["context"]["mutual_friends"]["summary"]["total_count"]
                       return @count
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
   if fees <= 8
   	@cut_off = fees.to_f * 0.80
   	return @cut_off 
   elsif fees > 8
     @cut_off = fees.to_f * 10/100
     return @cut_off 
   end
 end		

end
