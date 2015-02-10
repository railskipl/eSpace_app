# Dinobo

Find summer storage provided by other USC students, or rent out some space to
store other students' goods over the summer

## Development setup

Ruby version is in Gemfile; install it. Now let's go with the deps:
you need postgres installed. If you're on mac, you may do

```console
$ brew tap homebrew/boneyard
Unless you done it already.
$ brew bundle
```

Now gems:

```console
$ bundle install
```

Create `config/application.yml` [with secret data](https://tracker.anahoret.com/projects/171).

Now database:

```console
$ bin/rake db:create db:migrate db:seed
$ bin/rake db:create db:migrate RAILS_ENV=test
```

Now run tests, they should pass.

```
$ bin/rake spec
```

You're done!

## Development

Start server with `bin/rails s`. Run tests with `bin/rake test`.
Write tests. Write clean code. Primium nil nocere.

## Deployment

To production:

```console
$ git remote add production dokku@dinobo.com:production
$ git push production master
```

More in `docs/Deployment.md`.

## Other

Good test cards:

```
4242424242424242  Visa
4012888888881881  Visa
4000056655665556  Visa (debit)
5555555555554444  MasterCard
5200828282828210  MasterCard (debit)
5105105105105100  MasterCard (prepaid)
```

## Facebook

Facebook login is not very useful for us because the user has to verify email address in any case.
Hide the feature but leave the code there, so if we want it in the future, it will be easy to implement.
To restore this feature, you need to register environment variables (FACEBOOK_APP_ID, FACEBOOK_SECRET_KEY) in figaro.rb and application.yml
And also to generate environment variables on production:

```console
$ bin/dokku-remote config:set production FACEBOOK_APP_ID = **** FACEBOOK_SECRET_KEY = ***
```
