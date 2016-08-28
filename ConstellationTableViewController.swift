//
//  ConstellationTableViewController.swift
//  delphi
//
//  Created by Debparna Pratiher on 8/27/16.
//  Copyright © 2016 Debparna Pratiher. All rights reserved.
//



import UIKit

class ConstellationTableViewController: UIViewController {
    
    @IBOutlet var YearRound: UILabel!
    @IBOutlet var Hemisphere: UILabel!
    @IBOutlet var TextField2: UITextView!
    @IBOutlet var TextField1: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let localDB = NSUserDefaults.standardUserDefaults();
        let regionSeason = localDB.objectForKey("regionSeason") as? String!;
        let regionSeasonArray = regionSeason!.componentsSeparatedByString("");
        let constellations = localDB.objectForKey("constellations") as? NSDictionary;
//        let events = localDB.objectForKey("events") as? NSDictionary;
        let region = regionSeasonArray[0] as? String!;
        var yearRoundMessage: String = "";
        var regionHeader: String = "";
        if(region == "S"){
            regionHeader = "Year-round Southern";
            let polarArray = constellations!["SP"] as! NSArray;
            
            for(var i=0; i < polarArray.count; i++){
                yearRoundMessage += (polarArray[i] as! String) + "\n";
            }
        }
        else{
            regionHeader = "Year-round Northern";
            var polarArray = constellations!["NP"] as! NSArray;
            for(var i=0; i < polarArray.count; i++){
                yearRoundMessage += (polarArray[i] as! String) + "\n";
            }
        }
        
        
//        let season = regionSeasonArray[1];
        var seasonHeader = ""
        
        if(regionSeason == "SA"){
            seasonHeader = "Southern Autumn"
        }
        else if(regionSeason == "NA"){
            seasonHeader = "Northern Autumn"
        }
        else if(regionSeason == "SS"){
            seasonHeader = "Southern Spring"
        }
        else if(regionSeason == "NS"){
            seasonHeader = "Northern Spring"
        }
        else if(regionSeason == "SU"){
            seasonHeader = "Southern Summer"
        }
        else if(regionSeason == "NU"){
            seasonHeader = "Northern Summer"
        } else if(regionSeason == "SW"){
            seasonHeader = "Southern Winter"
        }
        else{
            seasonHeader = "Northern Winter"
        }
        
        
        let constellationsArray = constellations![regionSeason!] as! NSArray;
        
        var seasonsMessage: String = "";
        for(var i=0; i < constellationsArray.count; i++){
            seasonsMessage += (constellationsArray[i] as! String) + "\n";
        }
        Hemisphere.text = seasonHeader;
        YearRound.text = regionHeader;
        
        TextField1.text = seasonsMessage;
        TextField2.text = yearRoundMessage;
        
        print("hello");
        print(seasonsMessage);
        
        print("hello2");
        print(yearRoundMessage);
        
        
        
        
        
    }
}