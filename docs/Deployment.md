## Deploy

### dokku-remote

All dokku commands can be given either on remote host as `dokku
_command_`, or from developer machine as `ssh -t dokku@host.com
_command_`. To help with this, there is a script `bin/dokku-remote` that
reads `.dokkurc` file in application root folder and executes dokku
command remotedly. We highly recommend to alias it: `alias
dr="bin/dokku-remote"`. When server changes, you should change
`.dokkurc` file.

```console
$ dr logs staging -t # see the logs
$ dr run staging bash # run commands in the application
$ dr run staging bin/rake db:migrate # for example migrations
$ dr run staging bin/rails c # or run console
$ dr run postgresql:console staging staging_db # or connect to the
database
$ dr config staging # or manage configuration

where `staging` is the application instance name. [Check for the other
commands](https://github.com/dokku-alt/dokku-alt#help), they may be
incredibly useful.
```

### Deploy to production

```console
$ git remote add production dokku@dinobo.com:production
$ git push production master
```

Access at [dinobo.com](http://dinobo.com/).
Logs:

```console
$ dr logs production -t
```

### Set up a totally new enironment

Let's say you want to release `staging` on `yourdomain.com`.

* Create an instance on DigitalOcean using "Ubuntu 14.04". Use
  yourdomain.com as a hostname.
* Set up A-Record for yourdomain.com and *.yourdomain.com pointing to
   server ip address. Make sure it's resolvable in DNS before next step.
* Check `/home/dokku/VHOST`. It should containe one line:
  `yourdomain.com`
* Install [dokku-alt](https://github.com/dokku-alt/dokku-alt):

```console
$ sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh)" < /dev/null
```

* Add your key to deploy:

```console
$ cat ~/.ssh/id_rsa.pub | ssh root@yourdomain.com sudo dokku access:add"
```

* Deploy a root instance.

```console
$ ssh -t dokku@yourdomain.com postgresql:create staging_db.
$ git remote add staging dokku@yourdomain.com:staging
$ git push staging master
$ ssh -t dokku@yourdomain.com postgresql:link staging staging_db
$ ssh -t dokku@yourdomain.com domains:set staging yourdomain.com
```

* Don't forget to set configuration via `dr config:set`.
* Access at yourdomain.com

### Add another developer to deploy

```console
$ cat id_rsa.pub | ssh root@dinobo.com "sudo sshcommand acl-add dokku username"
or
$ pbpaste | ssh root@dinobo.com "sudo sshcommand acl-add dokku username"
```
