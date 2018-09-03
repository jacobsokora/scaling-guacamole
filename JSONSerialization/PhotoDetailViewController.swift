//
//  PhotoDetailViewController.swift
//  JSONSerialization
//
//  Created by Jacob Sokora on 9/2/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit
import MapKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var photo: Photo?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let image = image {
            imageView.image = image
        }
        if let photo = photo {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            titleLabel.text = photo.title
            descriptionLabel.text = photo.description
            dateLabel.text = formatter.string(from: photo.getDate())
            let annotation = PhotoAnnotation(photo: photo)
            mapView.addAnnotation(annotation)
            mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class PhotoAnnotation: NSObject, MKAnnotation {
    let photo: Photo
    let coordinate: CLLocationCoordinate2D
    
    init(photo: Photo) {
        self.photo = photo
        self.coordinate = CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude)
        super.init()
    }
    
    var title: String? {
        return photo.title
    }
}
