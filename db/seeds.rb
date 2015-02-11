# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'SETTING UP DEFAULT USER LOGIN'
User.reset_column_information
admin = User.new(:email => 'support@dinobo.com', :password => 'sxP7WsW3CdjRd3PV4CnX', :password_confirmation => 'sxP7WsW3CdjRd3PV4CnX', :admin => 'true')
admin.skip_confirmation!
admin.save!

puts 'SETTING UP DEFAULT EMAIL DOMAIN ALLOWED FOR SIGNUP'
AccessId.reset_column_information
AccessId.create! email: 'usc.edu'

puts 'SETTING UP DEFAULT CONTACT US SUBJECT'
Contactus.reset_column_information
Contactus.create! subject: 'General questions'
