//
//  ViewController.swift
//  iOScoutium
//
//  Created by Salim Uzun on 20.01.2021.
//

import UIKit
import Firebase
import NVActivityIndicatorView


class ViewController: UIViewController {
    
    let reachability = try! Reachability()

    var remoteConfig = RemoteConfig.remoteConfig()
    
    var flag = false
    
    @IBOutlet weak var startLogo: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.isHidden = true
        startLogo.isHidden = true
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.flag = true
            } else {
                print("Reachable via Cellular")
                self.flag = true
            }
            
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showAlert()
        }
        
        do {
            
            try reachability.startNotifier()
            
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Network Error", message: "Requires internet connection!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"OK\" alert occured.")
            exit(0)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        remoteConfig.fetchAndActivate{ (status, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if (status != .error && self.flag == true) {

                    if let welcomeMessage = self.remoteConfig["welcomeMessageConfigKey"].stringValue {
                        print("Welcome Message: \(welcomeMessage)")
                        self.welcomeLabel.text = welcomeMessage
                        self.welcomeLabel.isHidden = false
                        self.startLogo.isHidden = false
                            if self.flag == true {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                                    self.performSegue(withIdentifier: "toHome", sender: nil)
                                    //Go to next page after 3 seconds
                            }
                        }
                    }
                }
            }
        }
    }
}




