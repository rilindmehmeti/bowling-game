## README

In this project I simulated a Bowling game played by one user only. It is built by using `Ruby on Rails` framework.

In order to be able to achieve the desired functionality I added two models `Game` and `Frame`. `Game` game has an identifier and `Frame` contains all the necessary fields in order to be able to have the desired functionality.

The business logic is placed under `app/lib` directory there are 3 base modules `Games, Frames and Validators`. Inside each module there are classes that do certain jobs. For example `Frames::AddPoints` is responsible for adding points to a frame. `Frames::UpdatePreviousFrames` is responsible for updating the previous frames. `Frames::Validators::AddPoints` is responsible for validating the input of the `Frames::AddPoints`. 

In order to be able to interact with business logic of the application, I used services approach where basically each service is responsible to handle the request and do the right interactions with the rest of the application. The services can be found under `app/services`. 

As for the presentation of data, I have used `Serializers`, which can be found under `app/serializers`.

In order to unit test the code I have used `RSpec`.

I try to align my code with `SOLID` principles and use good naming of classes and variables in order to be easier to understand `who` does `what`.  
#### Requirements
* Ruby version `2.5.0p0`
* Bundler Version `1.16.5`

#### Installation
* Run `bundle install`
#### Database Configuration
* Run `rails db:setup`
* Run `rails db:migrate`
#### Running tests
* Run `bundle exec rspec`
#### Run Application
* Run `rails server`
#### API Endpoints for testing
* use `curl -X POST localhost:3000/v1/games/create` for game creation it gives back the `id` for the created game
* use `curl -X GET localhost:3000/v1/games/result/:id` to see the results for the game with given `:id`
* use `curl -X POST localhost:3000/v1/games/add_points -F id=:id -F points=:points` to add number of points `:points` for the game with id `:id`