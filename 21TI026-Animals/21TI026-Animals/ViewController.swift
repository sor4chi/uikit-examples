//
//  ViewController.swift
//  21TI026-Animals
//
//  Created by 川村空千 on 2023/08/30.
//

import UIKit

struct AnimalInfo {
    var id: Int
    var name: String
    var description: String
    var imageUrl: String
    var favorite: Bool
}

protocol AnimalInfoDelegate {
    func favorite(id: Int)
}

class ViewController: UIViewController, UITableViewDataSource, AnimalInfoDelegate {
    @IBOutlet weak var onlyFavoriteSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!

    var baseItems = [
        AnimalInfo(id: 1, name: "ライオン", description: "百獣の王。一般的の最も強い動物として知られている。", imageUrl: "https://plus.unsplash.com/premium_photo-1661962858972-6f3303ebd748?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1692&q=80",favorite: false),
        AnimalInfo(id: 2, name: "サイ", description: "頭部に固いツノを持っている。巨体に似合わず最高時速50kmで走る。", imageUrl: "https://images.unsplash.com/photo-1598894000396-bc30e0996899?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80",favorite: false),
        AnimalInfo(id: 3, name: "シマウマ", description: "白黒の縞模様を持つ動物。視覚や触覚、聴覚が優れている、", imageUrl: "https://images.unsplash.com/photo-1664793484534-497c51a08efb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80",favorite: false),
        AnimalInfo(id: 4, name: "キリン", description: "最も背が高い動物。首が長いところが特徴。", imageUrl: "https://images.unsplash.com/photo-1612358405970-e1aeba9d76c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1805&q=80",favorite: false),
        AnimalInfo(id: 5, name: "ゾウ", description: "陸生動物では世界最大の動物。鼻は立っていても地面につくほどに長い。", imageUrl: "https://images.unsplash.com/photo-1612143385179-01198b6065f7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80",favorite: false)
    ]

    var items: [AnimalInfo] {
        if onlyFavoriteSwitch.isOn {
            return baseItems.filter { $0.favorite }
        } else {
            return baseItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NameCell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRaw = tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DetailViewController
            controller.info = items[selectedRaw.row]
            controller.delegate = self
        }
    }

    func favorite(id: Int) {
        if let index = baseItems.firstIndex(where: { $0.id == id }) {
            baseItems[index].favorite.toggle()
            tableView.reloadData()
        }
    }

     @IBAction func toggleOnlyFavorite(_ sender: UISwitch) {
         tableView.reloadData()
     }
}

