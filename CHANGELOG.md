# Unreleased

* Hide Facebook login.

_akd 10.02.2015_

* Change 'from' address in contact us notifications.

_dak 09.02.2015_

* Use Mandrill for production email delivery.

_dak 09.02.2015_

* Change nonsensical text in cancel-popup windows.

_akd 09.02.2015_

* Remove confirm drop off feature.

akd 09.02.2015_

* Added mobile numder and login count to user info for admin.

_akd 09.02.2015_

* Remove unused eager loading on posts#overview and search.

_akd 06.02.2015_

* Attach application to new Facebook account.

_akd 06.02.2015_

* Move S3 configuration to environment variables.

_akd 06.02.2015_

* Remove registering Mime::PDF - it's already registered in Rails.

_akd 06.02.2015_

* Add figaro gem to maintain application configuration.

_akd 06.02.2015_

* Attach application to new Stripe account.

_akd 06.02.2015_

* Apply 12-factor rules to application: logs and port binding.

_akd 06.02.2015_


* Add deploy scripts to use `dinobo.com` dokku installation.

_akd 06.02.2015_


* Change 'from' email address to 'support@dinobo.com'.

_akd 06.02.2015_


* Removed "I agree term and condition" checkbox from login.

_akd 05.02.2015_

* Fixed multithreaded error in chat.

Even two different chats interfered with each other, resulting in duplicating
messages or non-delivered messages. This was fixed.

_akd 05.02.2015_

* Removed duplicate messages in chat.

When user opened messages page, last message was eventually duplicated. This
was fixed.

_akd 05.02.2015_

* Removed javascript injection in posts message.

_akd 05.02.2015_

* Remove js error in `animated_message.js` about undefined `Modernizr`.

_akd 05.02.2015_

* Make `bank_details` a singular resource: remove `show`, change `index` to
`show`, remove primary keys from routes.

A user can only have one `bank_details` record and no one should see or access
it except that user. So no need to have primary key in route to these
endpoints.

_akd 04.02.2015_

* Removed `bank_details#edit`, `bank_details#update`.

`bank_details` can't be edited - this results in Stripe changing the
subscription and it's much better to remove old bank details and create new.

_akd 04.02.2015_

* Resolved mass assignment issues in posts, bookings.

A user could create posts or bookings on behalf of other users. This was fixed.

_akd 04.02.2015_

* Resolved privilege escalation issues in profile, posts, bookings, orders,
bank details.

A user could gain unexpected read or write access to other users' items. This
was fixed.

_akd 04.02.2015_

# v1.0.0

* Application made.

# Authors

* [akd](https://github.com/KudryashovAV)
