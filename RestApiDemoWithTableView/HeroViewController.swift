//
//  HeroViewController.swift
//  RestApiDemoWithTableView
//
//  Created by Appinventiv on 15/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var legsLbl: UILabel!
    @IBOutlet weak var attackType: UILabel!
    @IBOutlet weak var attributeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var hero:HeroStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = hero?.localized_name
        attributeLbl.text = hero?.primary_attr
        legsLbl.text = "\((hero?.legs)!)"
        attackType.text = hero?.attack_type
        let urlString = "https://api.opendota.com" + (hero?.img)!
        let url = URL(string: urlString)
        imageView.downloadedFrom(url: url!)
    }

}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
