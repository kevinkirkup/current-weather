# current-weather
macOS Application to retrieve the current weather conditions for your location

This application uses the Dark Sky API to request the weather forcast for the specified
location. You will need to request and API Key from the [Dark Sky API website](https://darksky.net/dev/).
The first 1000 requests per day are free.

The DARKSKY_API_KEY is read from your environment.
Longitude and Latitude are passed in as a comma separated string, no spaces.

The current version doesn't validate you coordinates, so if you aren't seeing any
data being printed, please check your coordinates are valid.

Example:

```sh
$ DARKSKY_API_KEY=<YOUR API KEY> ./current_weather.swift 38.0091,-78.4539
Light rain starting in 13 min., stopping 30 min. later.
```
