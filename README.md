# yourwaste-ie

A rails app that powers [www.yourwaste.ie](https://www.yourwaste.ie).

## Local development

I'm assuming you have `rbenv` or `rvm` set up? And `homebrew`?

Next, install `PostgreSQL` and `redis` and start both services:

```bash
brew install postgresql
brew install redis
```

Now clone the repo, install the dependencies, and set up the db.

```bash
git clone https://github.com/civictech-ie/yourwaste-ie
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

Get things started:

```bash
heroku local
```

and, optionally:

```bash
guard
```
