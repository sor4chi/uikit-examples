//
//  ViewController.swift
//  21TI026-PhotoViewer
//
//  Created by 川村空千 on 2023/08/30.
//

import UIKit
import Photos

protocol DetailViewControllerDelegate {
    func getPrev(currentIndex: Int) -> PHAsset
    func getNext(currentIndex: Int) -> PHAsset
    func getMaximumIndex() -> Int
}

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DetailViewControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [PHAsset] = []
    let manager = PHImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                self.loadPhotos()
            }
        }
    }

    func loadPhotos() {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        let indexSet = IndexSet(integersIn: 0...result.count - 1)
        let loadedPhotos = result.objects(at: indexSet)
        photos = loadedPhotos
        DispatchQueue.main.sync {
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let asset = photos[indexPath.item]
        let width = collectionView.bounds.size.width / 3
        manager.requestImage(for: asset, targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: nil, resultHandler: { result, info in
            if let image = result {
                let imageView = cell.viewWithTag(1) as! UIImageView
                imageView.image = image
            }
        })

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            vc.delegate = self
            vc.asset = photos[indexPath.item]
            vc.currentIndex = indexPath.item
        }
    }

    func getPrev(currentIndex: Int) -> PHAsset {
        return photos[currentIndex - 1]
    }

    func getNext(currentIndex: Int) -> PHAsset {
        return photos[currentIndex + 1]
    }

    func getMaximumIndex() -> Int {
        return photos.count - 1
    }
}

