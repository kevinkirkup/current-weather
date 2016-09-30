#!/usr/bin/env swift

//: Playground - noun: a place where people can play

import Foundation

#if os(Linux)
import Dispatch
#endif

//: TODO Request current location from the location manager
// https://developer.apple.com/reference/corelocation/cllocationmanager

var latitude = String(35.7804)
var longitude = String(-78.6382)

let arguments = CommandLine.arguments

if arguments.count >= 2 {

  let long_lat = arguments[1].components(separatedBy: ",")

  if long_lat.count == 2 {

    latitude = long_lat[0]
    longitude = long_lat[1]
  }

} else {
  print("Invalid Longitude/Latitude, using default.")
}

// Replace with your Dark Sky API Key
// https://darksky.net/dev/

//let apiKey = "YOUR API KEY"
// or
// Get the Dark Sky API Key from the environment
let environment = ProcessInfo.processInfo.environment
guard let apiKey = environment["DARKSKY_API_KEY"] else {
    print("Dark Sky API Key not specified")
    exit(1)
}

guard let url = URL(string:
"https://api.darksky.net/forecast/\(apiKey)/\(latitude),\(longitude)?exclude=currently,hourly,daily,flags") else {
    print("Error creating request URL")
    exit(1)
}

let semaphore = DispatchSemaphore(value: 0)

// Create a URL Request & handle the response data
var request = URLRequest(url: url)
request.httpMethod = "GET"

#if os(Linux)
let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)
#else
let session = URLSession.shared
#endif

// Create the Data Task to request the Weather data from Dark Sky
let task = session.dataTask(with: request, completionHandler: { (returnData, response, error) in

    var strData = NSString(data: returnData!, encoding: String.Encoding.utf8.rawValue)

    do {

        guard let jsonObject = try JSONSerialization.jsonObject(with: returnData!, options: []) as? [String: Any] else {
          print("No weather data available!")
          return
        }

        //
        // Display Alerts
        //
        if let alerts = jsonObject["alerts"] as? [[String: Any]] {

          for alert in alerts {

            if let description = alert["description"],
               let title = alert["title"] {
              print("Alert: \(title)")
            }
          }
        }

        //
        // Display the current weather summary
        //
        if let minutely = jsonObject["minutely"] as? [String: Any] {

          if let summary = minutely["summary"] as? String {
            print("\(summary)")
          }
        }

    } catch {
      print("Weather Data Not Available.")
    }

    semaphore.signal()

})

// Send the request and wait for a response
task.resume()
_ = semaphore.wait(timeout: .distantFuture)

