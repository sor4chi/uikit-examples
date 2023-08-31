//
//  DetailViewController.swift
//  21TI026-PhotoViewer
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit
import Photos

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPageLabel: UILabel!
    var asset: PHAsset!
    var delegate: DetailViewControllerDelegate!
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = PHImageManager()
        manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil, resultHandler: { result, info in
            if let image = result {
                self.imageView.image = image
                self.titleLabel.text = self.formatDateTime(date: self.asset.creationDate!)
            }
        })
        let maximumIndex = delegate.getMaximumIndex()
        currentPageLabel.text = "\(currentIndex + 1) / \(maximumIndex + 1)"
    }

    func formatDateTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }

    @IBAction func prevButtonTapped(_ sender: Any) {
        if currentIndex > 0 {
            let prevAsset = delegate.getPrev(currentIndex: currentIndex)
            let transition = CATransition()

            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

            transition.type = CATransitionType.push

            transition.subtype = CATransitionSubtype.fromLeft

            self.navigationController!.view.layer.add(transition, forKey: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            detailViewController.asset = prevAsset
            detailViewController.delegate = delegate
            detailViewController.currentIndex = currentIndex - 1
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        let maximumIndex = delegate.getMaximumIndex()
        if currentIndex < maximumIndex {
            let nextAsset = delegate.getNext(currentIndex: currentIndex)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            detailViewController.asset = nextAsset
            detailViewController.delegate = delegate
            detailViewController.currentIndex = currentIndex + 1
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
