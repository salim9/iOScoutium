//
//  Home.swift
//  iOScoutium
//
//  Created by Salim Uzun on 21.01.2021.
//

import UIKit
import NVActivityIndicatorView //Loading animation library
import Alamofire
import SwiftyJSON
import AlamofireImage

class Home: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    var myList = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
        
    }
    
    
    fileprivate func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseSync, color:.init(red: 18/255, green: 201/255, blue: 146/255, alpha: 1), padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            loading.stopAnimating()
            self.getJSONData()
        }
    }
    
    func getJSONData() {

        let urlFile = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/data.json"
        Alamofire.request(urlFile).responseJSON { (response) in
            switch response.result
            {
            
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value!)
                if let resData = swiftyJsonVar["items"].arrayObject {
                self.myList = resData as! [[String:Any]]
                }
                self.myTable.reloadData()
            
            case .failure(let error):
                print("Error occured \(error.localizedDescription)")
                
                }
            }
        }

}

extension Home: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell

        var dict = myList[indexPath.row]
        cell.myLabel.text = dict["title"] as? String
        let sourceFeed = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/"
        let copyUrl = dict["url"] as? String
        let urlImage = (sourceFeed + copyUrl! ?? nil) as? String
  
        Alamofire.request(urlImage!).responseImage { (response) in
            if let image = response.result.value
            {
                
                DispatchQueue.main.async{
                    cell.myImage.layer.cornerRadius = 8.0
                    cell.myImage.clipsToBounds = true
                    cell.myImage.image = image
                    
                }
                
            }
            
        }
        
        return cell
    }
    
    
}
