//
//  DetailViewController.swift
//  21TI026-Animals
//
//  Created by 川村空千 on 2023/08/30.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: URLImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    var info: AnimalInfo!
    var delegate: AnimalInfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = info.name
        label.text = info.description
        image.imageURL = URL(string: info.imageUrl)
    }

    @IBAction func toggleFavorite(_ sender: UIButton) {
        delegate?.favorite(id: info.id)
        info.favorite.toggle()
        updateFavoriteButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        if info.favorite {
            favoriteButton.tintColor = .systemYellow
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.tintColor = .systemGray
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
