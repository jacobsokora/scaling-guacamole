//
//  ViewController.swift
//  JSONSerialization
//
//  Created by Jacob Sokora on 9/2/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var photos = [Photo]()
    let baseUrl = "https://dalemusser.com/code/examples/data/nocaltrip/"
    var photosPath: String?
    var useCodable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        if let flowLayout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 1
            flowLayout.minimumLineSpacing = 1
            let horizontalSpacing = flowLayout.minimumInteritemSpacing
            let numberOfCellsPerRow = 4
            let cellWidth = (view.frame.width - CGFloat(max(0, numberOfCellsPerRow - 1)) * horizontalSpacing) / CGFloat(numberOfCellsPerRow)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
        
        photosCollectionView.refreshControl = UIRefreshControl()
        photosCollectionView.refreshControl?.beginRefreshing()
        loadWithCodable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchProtocol(_ sender: UIBarButtonItem) {
        photosCollectionView.refreshControl?.beginRefreshing()
        if useCodable {
            loadWithCodable()
            sender.title = "Switch to codable"
        } else {
            loadWithSerializer()
            sender.title = "Switch to serializer"
        }
        useCodable = !useCodable
    }
    
    func loadWithCodable() {
        Response.getPhotosDataCodable { response in
            if let response = response, response.status == "ok" {
                print(response.photosPath)
                self.photosPath = response.photosPath
                self.photos = response.photos
                self.photosCollectionView.reloadData()
            }
            self.photosCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func loadWithSerializer() {
        Response.getPhotosDataSerialized { response in
            if let response = response, response.status == "ok" {
                self.photosPath = response.photosPath
                self.photos = response.photos
            }
            self.photosCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoDetailViewController, let selected = photosCollectionView.indexPathsForSelectedItems?.first {
            destination.photo = photos[selected.item]
            destination.image = (photosCollectionView.cellForItem(at: selected) as? PhotoCollectionViewCell)?.imageView.image
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        if let photoCell = cell as? PhotoCollectionViewCell {
            let imageUrl = baseUrl + (photosPath ?? "") + "/" + photos[indexPath.item].image
            if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                photoCell.imageView.image = image
            }
        }
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

