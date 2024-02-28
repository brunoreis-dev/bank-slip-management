# Bank Slip Management

Ruby on Rails application to manage Bank Slips.

## Functionality

- I can see all the bank splips on the list in an overview.
- I can add a bank slip.
- I can edit a bank slip.
- I can cancel a bank spli.

## Running the app

Clone this repo:

```
$ git clone https://github.com/brunoreis-dev/bank-slip-management.git
```

Install all dependancies:

```
$ bundle install
```

Create the postgresql image on Docker:

```
$ docker-compose up
```

Create the database and run migrations:

```
$ rake db:create db:migrate
```

Run seeds:

```
$ rake db:seed
```

Start the server:

```
$ rails server
```

And open the app in your browser at http://localhost:3000.

## Interactive Console

Open Console:

```
$ rails console
```

## Testing the app

Run the tests:

```
$ rake
```

## Useful documentation

- [Ruby on Rails guides](http://guides.rubyonrails.org/)
