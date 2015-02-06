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
