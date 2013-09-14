# What do I need to doto get started?

* Get [perlbrew](http://perlbrew.pl/) and build and install a perl.
* Pull down the git repo
* `cpanm --installdeps .`
* `perl bin/deploy.pl` - this will set up a schema for your dev database
* `perl bin/app.pl` - this will start the app up on port 3000

# Where do I make pull requests?

* develop on [the main repo](https://github.com/worr/pval)

I'll merge it into master when I'm ready to make a release

# Do I need memcached?

No, but it makes everything faster! pval will use memcached if it's available,
but it's not a requirement. memcached needs to be started before pval is.

# How do I configure pval?

Use `config.yml`, `environments/development.yml` and
`environments/production.yml`. The last two are environment specific, so make
changes in the appropriate file. `config.yml` is global, and the
environment-specific ones override it.

# What kind of features will get merged in?

Most things, as long as they're written securely and with performance in mind.
Be careful about changing the database schema. I'll be more hesitant to
merge in features requiring schema changes.

# What about adding deps?

I don't care. I deploy with perlbrew so I frankly don't give a fuck about how
many deps this has. You do you.
