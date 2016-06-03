# story.board
[![Build Status](https://travis-ci.org/roschaefer/story.board.svg?branch=master)](https://travis-ci.org/roschaefer/story.board)

This is the user interface for journalists and readers of the [sensor live report](https://youtu.be/KIya_ptoFlU?t=44m50s).

## Installation

Make sure you have ruby version 2.3.1 installed on your system.

1. Clone the repository:
    ```
    git clone https://github.com/roschaefer/story.board.git
    ```

2. Install dependencies
    ```
    cd story.board
    bundle install
    ```

3. Run database migrations
    ```
    bin/rake db:migrate
    ```

4. Seed the database
    ```
    bin/rake db:seed
    ```

## Usage

Start the app with:
  ```
  bin/rails server
  ```

And point your browser to your [running instance](http://localhost:3000/).


## Test

We use rspec for unit and functional testing and cucumber for integration testing. You can run all the tests with:

  ```
  bin/rake
  ```

Or selectively
  ```
  bin/rake spec
  bin/rake cucumber
  ```
## Documentation

We are [cucumber evangelists](https://cucumber.io/). See our executable, up-to-date documentation on [relishapp](http://www.relishapp.com/sensor-live-report/story-board/).

## Contribute

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Run the tests: `bin/rake`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :heart:





