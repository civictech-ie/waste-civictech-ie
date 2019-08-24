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

The `.env.sample` file has the environment variables you'll need to get started:

```bash
cp .env.sample .env
```

Get the thing running:

```bash
heroku local
```

and, optionally for live reloading:

```bash
guard
```

And then head to [http://localhost:5000](http://localhost:5000).

## Tests

Run the tests before committing code (and write a few):

```bash
rake
```

## Credentials

You'll need to set a Google API key in a `credentials.yml` file or get the `master.key` file from another contributor (email brian@civictech.ie and I'll respond promptly!).

## Seed data

The app can be seeded from a properly formatted Google Sheets document (assuming you're credentialed per the above section).

Running `rake db:seed` will fetch the data from Google Sheets and insert it into the app's Postgresql database. _Note: this will replace any existing data you have in the local database._