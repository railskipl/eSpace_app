module PostsHelper
 def mutual_count(user)
   @user_fb_token = current_user.oauth_token
   @users = User.find_by_id(user)
   @graph = Koala::Facebook::API.new(@users.oauth_token) 
   @graph1 = Koala::Facebook::API.new(@user_fb_token)
   @mutual = @graph.get_object("me")
   @mutual_friends = @graph1.get_connections("me", "mutualfriends/#{@mutual["id"]}")
   return @mutual_friends.count	
 end

 def processing_fees(fees)
   if fees <= 8
   	@cut_off = fees * 0.80
   	return @cut_off 
   elsif fees > 8
     fees * 10/100
   end
 end		

end
