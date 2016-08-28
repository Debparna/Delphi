//
//  LaunchScreenViewController.swift
//  delphi
//
//  Created by Debparna Pratiher on 8/28/16.
//  Copyright © 2016 Debparna Pratiher. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class LaunchScreenViewController: UIViewController {
    
    var player: AVPlayer?
    var window: UIWindow?

    @IBAction func showHomePage(sender: AnyObject) {
        print("dsflakdsnfs");
        getWeatherData(sender);
        
    }
    
    func getWeatherData(sender: AnyObject){
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let lat = 22
        let long = 123
        
        //let urlString = "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&mode=json&appid=b2b835ef40de8ef8c16167c2a6f6f5bc" // Your Normal URL String
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=SanFrancisco,&mode=json&appid=8dd039b67c6ecbd39bdbbf52ff4f72e8" // Your Normal URL String
        let url = NSURL(string: urlString)// Creating URL
        let request = NSURLRequest(URL: url!) // Creating Http Request
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        // Sending Synchronous request using NSURLConnection
        do {
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            
            let json = jsonDictionary
            
            if json.count > 0 {
                let dayData = json["list"]
                var daysCount: [Int] = []
                for(var i = 0; i < 8; i += 1){
                    
                    let sysData = dayData![i]["sys"] as AnyObject!
                    let podData: String = (sysData["pod"] as? String)!
                    
                    if (podData == "n"){
                        let weatherArray = dayData![i]["weather"] as! NSArray
                        let weatherObj = weatherArray[0] as AnyObject!
                        let currentWeatherId: Int = (weatherObj["id"] as? Int)!;
                        
                        if(currentWeatherId == 800){
                            print("Hey Clear Sky! 1)")
                            
                            //temperature logic
                            let mainObj = dayData![i]["main"]
                            let tempData: Double = (mainObj!!["temp"] as? Double)!
                            let fTemp: Double = tempData*(1.8) - 459.67
                            let roundTemp = Int(round(fTemp))
                            localDB.setObject(roundTemp, forKey: "currentTemp")
                            
                            print(roundTemp)
                            if(daysCount.count >= 1)
                            {
                                break
                            }
                            // Transfer to Screen 1
                            presentYesViewController(animated: false,sender: sender)
                            break;
                        }
                        else {
                            var isClearSky: Bool = false
                            for(var j=i+8; j < dayData!.count; j = j+8){
                                let sysData = dayData![j]["sys"] as AnyObject!
                                let podData: String = (sysData["pod"] as? String)!
                                
                                if (podData == "n"){
                                    let weatherArray = dayData![j]["weather"] as? NSArray
                                    let weatherObj = weatherArray![0] as AnyObject!
                                    let currentWeatherId: Int = (weatherObj["id"] as? Int)!
                                    
                                    if(currentWeatherId == 800){
                                        print("Hey Clear Sky! 2)")
                                        isClearSky = true
                                        let days: Int = (j - i)/8
                                        
                                        daysCount.append(days)
                                        localDB.setObject(daysCount[0], forKey: "daysToNextEvent")
                                        print("You can go stargazing in " + String(days) + " days.")
                                        // Transfer to Screen 2
                                        presentNoViewController(animated: false, sender: sender)
                                        break;
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            if(isClearSky == false){
                                print("No clear sky")
                                // Transfer to Screen 2
                                presentNoViewController(animated: false, sender: sender)
                                break;
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
        } catch (let e) {
            print(e)
            // You can handle error response here
        }
        
    }
    
    func presentYesViewController(animated animated: Bool,sender: AnyObject) {
        print("Presenting YesViewController")
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //        let navBarController = storyboard.instantiateViewControllerWithIdentifier("YesViewController")
        //        self.window?.makeKeyAndVisible()
        //        self.window?.rootViewController = navBarController
        self.performSegueWithIdentifier("showYesPage", sender: sender);
        
    }
    
    func presentNoViewController(animated animated: Bool,sender: AnyObject) {
        print("Presenting NoViewController")
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //        let navBarController = storyboard.instantiateViewControllerWithIdentifier("NoViewController")
        //        self.window?.makeKeyAndVisible()
        //        self.window?.rootViewController = navBarController
        
        self.performSegueWithIdentifier("showNoPage", sender: sender);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(LaunchScreenViewController.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
        
        // Do any additional setup after loading the view.
    }
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
