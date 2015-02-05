# Unreleased

* Remove js error in `animated_message.js` about undefined `Modernizr`.
_akd_

* Make `bank_details` a singular resource: remove `show`, change `index` to
`show`, remove primary keys from routes.
A user can only have one `bank_details` record and no one should see or access
it except that user. So no need to have primary key in route to these
endpoints.
_akd_

* Removed `bank_details#edit`, `bank_details#update`.
`bank_details` can't be edited - this results in Stripe changing the
subscription and it's much better to remove old bank details and create new.
_akd_

* Resolved mass assignment issues in posts, bookings.
So that users can no more create posts or bookings on behalf of other users.
_akd_

* Resolved privilege escalation issues in profile, posts, bookings, orders,
bank details.
So that users can no more gain unexpected read or write access to other users'
items.
_akd_

# v1.0.0

* Application made.

# Authors

* [akd](https://github.com/KudryashovAV)
