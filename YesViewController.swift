//
//  YesViewController.swift
//  delphi
//
//  Created by Debparna Pratiher on 8/27/16.
//  Copyright © 2016 Debparna Pratiher. All rights reserved.
//

//
//  ViewController.swift
//  Location Demo
//
//  Created by Kavitha Dhanukodi on 8/27/16.
//  Copyright © 2016 delphi. All rights reserved.
//

//
//  ViewController.swift
//  Location Demo
//
//  Created by schang16 on 8/27/16.
//  Copyright © 2016 schang16. All rights reserved.
//

import UIKit
import CoreLocation

class YesViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var textTemperature: UILabel!
 
    @IBOutlet var txtHemisphere: UILabel!
    
    var locationManager = CLLocationManager()
    var localDB1 = NSUserDefaults.standardUserDefaults();
    // N: North, S: South
    // A: Autumn, S: Spring, U: Summer, W: Winter
    // Keys: ["NA", "SS"], ["NW", "SU"], ["NS", SA], ["NU", "SW"], ["NP"], ["SP"]
    // Values: Constellations respective to keys
    
    //MARK: Properties
    
    
    var constellations =
        [
            "NA" : ["Andromeda", "Aquarius", "Aries", "Cetus", "Grus", "Lacerta", "Pegasus", "Perseus", "Phoenix", "Piscis Austrinus", "Pisces", "Sculptor", "Triangulum"],
            "SS" : ["Andromeda", "Aquarius", "Aries", "Cetus", "Grus", "Lacerta", "Pegasus", "Perseus", "Phoenix", "Piscis Austrinus", "Pisces", "Sculptor", "Triangulum"],
            "NW" : ["Auriga", "Calum", "Canis Major", "Canis Minor", "Carina", "Columba", "Eridanus", "Fornax", "Gemini", "Horologium", "Lepus", "Monoceros", "Orion", "Pictor", "Puppis", "Reticulum", "Taurus", "Vela"],
            "SU" : ["Auriga", "Calum", "Canis Major", "Canis Minor", "Carina", "Columba", "Eridanus", "Fornax", "Gemini", "Horologium", "Lepus", "Monoceros", "Orion", "Pictor", "Puppis", "Reticulum", "Taurus", "Vela"],
            "NS" : ["Antlia", "Boötes", "Cancer", "Canes Venatici", "Centaurus", "Coma Berenices", "Corvus", "Crater", "Hydra", "Leo", "Leo Minor", "Lupus", "Lynx", "Pyxis", "Sextans", "Virgo"],
            "SA": ["Antlia", "Boötes", "Cancer", "Canes Venatici", "Centaurus", "Coma Berenices", "Corvus", "Crater", "Hydra", "Leo", "Leo Minor", "Lupus", "Lynx", "Pyxis", "Sextans", "Virgo"],
            "NU" : ["Aquila", "Ara", "Capricornus", "Corona Australis", "Corona Borealis", "Cygnus", "Hercules", "Delphinus", "Equuleus", "Indus", "Libra", "Lyra", "Microscopium", "Ophiuchus", "Scorpius", "Scutum", "Serpens", "Sagitta", "Sagittarius", "Telescopium", "Vulpecula"],
            "SW" : ["Aquila", "Ara", "Capricornus", "Corona Australis", "Corona Borealis", "Cygnus", "Hercules", "Delphinus", "Equuleus", "Indus", "Libra", "Lyra", "Microscopium", "Ophiuchus", "Scorpius", "Scutum", "Serpens", "Sagitta", "Sagittarius", "Telescopium", "Vulpecula"],
            "NP" : ["Camelopardus", "Cassiopeia", "Cepheus", "Draco", "Ursa Major", "Ursa Minor"],
            "SP" : ["Apus", "Chamaeleon", "Circinus", "Crux", "Dorado", "Hydrus", "Mensa", "Musca", "Norma", "Octans", "Pavo", "Triangulum Australe", "Tucana", "Volans"]
    ];
    
    var events =
        [
            "8/28/16"  : "Giant Meteor",
            "9/1/16"  : "New Moon",
            "9/2/16" : "Annular Solar Eclipse",
            "9/3/16" : "Neptune at Opposition",
            "9/16/16"  : "Full Moon",
            "9/17/16"  : "Penumbral Lunar Eclipse",
            "9/22/16"  : "September Equinox",
            "9/28/16"  : "Mercury at Greatest Western Elongation",
            "10/1/16"  : "New Moon",
            "10/7/16"  : "Draconids Meteor Shower",
            "10/15/16" :  "Uranus at Opposition",
            "10/16/16" :  "Full Moon Supermoon",
            "10/20/16" :  "Orionids Meteor Shower",
            "10/30/16" :  "New Moon",
            "11/4/16" : "Taurids Meteor Shower",
            "11/14/16" :  "Full Moon Supermoon",
            "11/16/16" :  "Leonids Meteor Shower",
            "11/29/16" :  "New Moon",
            "12/11/16" :  "Mercury at Greatest Eastern Elongation",
            "12/13/16" : "Geminids Meteor Shower",
            "12/14/16" :  "Full Moon, Supermoon",
            "12/21/16" :  "December Solstice",
            "12/22/16" :  "Ursids Meteor Shower",
            "12/29/16" : "New Moon"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localDB = NSUserDefaults.standardUserDefaults()
        let currentTemp = localDB.objectForKey("currentTemp") as! Int;
        textTemperature.text = String(currentTemp);

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        localDB.setObject(constellations, forKey: "constellations");
        localDB.setObject(events, forKey: "events");
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        let localDB =  NSUserDefaults.standardUserDefaults();
        
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
      
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        let regionSeason = region(Int(lat), date: convertedDate)
        localDB.setObject(regionSeason, forKey: "regionSeason");
        for constellation in constellations[regionSeason]! {
            print(constellation)
        }
        
        if (events[convertedDate] != nil) {
            print("There's an event today" + events[convertedDate]!)
        }
        
        for event in events {
            print(event)
        }
        
        // print(constellations[regionSeason])
        // print(constellations)
        // someFunc(lat, date)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    @IBAction func getCurrentLoc(sender: AnyObject) {
//        locationManager.requestLocation()
//    }
    
    
    
    
    func region(lat: Int, date: String) -> String
    {
        var hemisphere:String!;
        var season:String!;
        var reg:String!;
        var m:String!;
        var monthValue: Int!
        
        var arr = date.componentsSeparatedByString("/");
        m = arr[1];
        monthValue = Int(m);
        
        if (lat >= 0) //Northern Hemisphere
        {
            hemisphere = "N";
            
            if((monthValue >= 3) && (monthValue <= 5)){
                season = "S";}
            else if ((monthValue >= 6) && (monthValue <= 8)){
                season = "U";}
            else if ((monthValue >= 9) && (monthValue <= 11)){
                season = "A";}
            else{
                season = "W";}
            
            txtHemisphere.text = "Northern";
        }
            
        else {
            hemisphere = "S";
              txtHemisphere.text = "Southern";
            if((monthValue >= 3) && (monthValue <= 5)){
                season = "A";}
            else if ((monthValue >= 6) && (monthValue <= 8)){
                season = "W";}
            else if ((monthValue >= 9) && (monthValue <= 11)){
                season = "S";}
            else{
                season = "U";}
            
            txtHemisphere.text = "Southern";
        }
        
        reg = hemisphere + season;
        
        return reg;
    }
    
}




