//
//  PhotosCodable.swift
//  JSONSerialization
//
//  Created by Jacob Sokora on 9/2/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import Foundation

struct Photo: Codable {
    
    let image: String
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    let date: String
    
    func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: date) ?? Date()
    }
}

struct Response: Codable {
    let status: String
    let photosPath: String
    let photos: [Photo]
    
    init(status: String, photosPath: String, photosDict: [[String: Any]]) {
        self.status = status
        self.photosPath = photosPath
        var photos = [Photo]()
        for dict in photosDict {
            let image = dict["image"] as! String
            let title = dict["title"] as! String
            let description = dict["title"] as! String
            let latitude = dict["latitude"] as! Double
            let longitude = dict["longitude"] as! Double
            let date = dict["date"] as! String
            photos.append(Photo(image: image, title: title, description: description, latitude: latitude, longitude: longitude, date: date))
        }
        self.photos = photos
    }
    
    static func getPhotosDataCodable(_ completion: ((Response?) -> Void)?) {
        guard let url = URL(string: "https://dalemusser.com/code/examples/data/nocaltrip/photos.json") else {
            completion?(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let responses = try decoder.decode(Response.self, from: data)
                        completion?(responses)
                    } catch {
                        completion?(nil)
                    }
                }
                completion?(nil)
            }
        }
        task.resume()
    }
    
    static func getPhotosDataSerialized(_ completion: ((Response?) -> Void)?) {
        guard let url = URL(string: "https://dalemusser.com/code/examples/data/nocaltrip/photos.json") else {
            completion?(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let jsonData = json as? [String: Any] else {
                            completion?(nil)
                            return
                        }
                        if jsonData["status"] as! String == "ok" {
                            let responses = Response(status: "ok", photosPath: jsonData["photosPath"] as! String, photosDict: jsonData["photos"] as! [[String: Any]])
                            completion?(responses)
                        }
                    } catch {
                        completion?(nil)
                    }
                }
                completion?(nil)
            }
        }
        task.resume()
    }
}
