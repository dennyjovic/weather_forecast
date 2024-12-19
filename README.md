# Weather Forecaster

## Explanation

This app takes in an address and returns to the user the weather forecast for today, including the high/low as well as the 7 day forecast (high/low as well).

## Strategy

My strategy with any piece of code is to make this simple and clear. I want to make it so that a non developer can read the code and potentially understand what is going on. I only added gems when I felt I needed them to accomplish the goal here. For example, I generally use the gem 'slim' in my views, but its not needed here because its a preference, so therefore I opted to leave it out. I did add 'bootstrap' but that was with the intention of taking the UI a little further to make is slightly more visually appealing.

## With more time I would do the following...

- Record real responses from the Geocoder API and the open-meteo API using something like the VCR gem.
	- This would give actual real life data to better test against

- Deploy this app in production to see it working live
	- There is enough complexity around deploying and setting up a new production environment that I chose to spend my time on writing the code and specs for it.

- Spend more time on the front end design
	- I gave a very bare-bones HTML/CSS pass but I would have preferred to spend a little more time on it

- As noted in the code, be more aware of timestamps instead of simply using index to select elements
	- I felt confident/comfortable enough to proceed with the index approach to not over-complicate the code and because the API seemed to work very smoothly with this approach.

