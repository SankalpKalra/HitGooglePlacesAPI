//
//  ViewController.swift
//  RestApiDemo
//
//  Created by Appinventiv on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var activtySpinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var placeName:String?
    var places:Places?
    let char5: Character = "\u{2605}"
    //var flag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        self.spin()
    }
    
    func tableViewDelegateCall(){
        tableView.isHidden = true
        tableView.delegate=self
        tableView.dataSource=self
    }
    
    func spin(){
        self.activtySpinner.hidesWhenStopped = true
        activtySpinner.stopAnimating()
    }
    
    
    
    func timerSch(){
        Timer.scheduledTimer(withTimeInterval:5, repeats: false) { (true) in
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.activtySpinner.stopAnimating()
        }
        
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        //        if !flag{
        //            places = nil
        //            //flag = !flag
        //        }
        activtySpinner.startAnimating()
        placeName = searchBar.text!.replacingOccurrences(of: " ", with: "+")
        self.getData()
        tableViewDelegateCall()
        timerSch()
    }
    
    func getData(){
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(placeName!)&key=AIzaSyAIrAqx2jxYilueXxLB6pseTrdDgNYLf5o")
        print(url!)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            do{
                guard let data = data else { return }
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                self.places = Places(json: json!)
            }catch{
                print("Serializable Error")
            }
            }.resume()
        
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (places?.results.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.alpha = 0
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
            UIView.animate(withDuration: 1) {
                cell.alpha = 1
                
                cell.layer.transform = CATransform3DIdentity
            }
    
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        if places?.status == "OK"{
            cell.name.text = places?.results[indexPath.row].name
            if self.places?.results[indexPath.row].rating == -1{
                cell.id.isHidden=true
            }
            else{
                cell.id.isHidden=false
                cell.id.text = "\((self.places?.results[indexPath.row].rating)!)" + " \(char5)"
            }
            cell.address.text = self.places?.results[indexPath.row].formatted_address
            if let photos = self.places?.results[indexPath.row].photos,!photos.isEmpty {
                let width = photos[0].width
                let height = photos[0].height
                cell.icon.downloadedFrom(link: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(width)&maxheight=\(height)&photoreference=\(photos[0].photo_reference)&key=AIzaSyAIrAqx2jxYilueXxLB6pseTrdDgNYLf5o")
            }
            return cell
        }
        else if places?.status == "OVER_QUERY_LIMIT"{
            cell.id.text = "OVER_QUERY_LIMIT"
            return cell
        }
        else {
            cell.id.text = "REQUEST_DENIED"
            return cell
        }
    }
}

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

