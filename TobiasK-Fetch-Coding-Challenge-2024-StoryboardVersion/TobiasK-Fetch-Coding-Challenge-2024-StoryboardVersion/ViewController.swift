//  ViewController.swift
//  TobiasK-Fetch-Coding-Challenge-2024-StoryboardVersion
//  Created by Katrina Tobias on 7/1/24.

import UIKit

// class used to define the Dessert TableView cell
class DessertCell: UITableViewCell {
    @IBOutlet weak var dessertNameLabel: UILabel!
}

// struct that contains the dessert info such as its id and image
struct dessertInfo {
    let dessertID: String
    let dessertImg: URL
}

// Main ViewController class that displays the list of desserts in alphabetical order
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // variables
    var dessertList:[String: dessertInfo] = [:]
    var dessertNames:[String] = []
    let dessertCellIdentifier = "DessertCellIdentifier"
    var request = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
    
    // outlets
    @IBOutlet weak var dessertTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dessertTableView.delegate = self
        dessertTableView.dataSource = self
        
        // Async call to fetch the names of the desserts from the API
        Task { @MainActor in
            do {
                dessertList = try await populateList()
                dessertNames = Array(dessertList.keys)
            } catch {
                print(error)
            }
            dessertNames = dessertNames.sorted()
            dessertTableView.reloadData()
        }
        
        
    }
    
    // function that returns the number of items in the table; dependent on the number of desserts in list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dessertNames.count
    }
    
    // function that assigns the text label in each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dessertTableView.dequeueReusableCell(withIdentifier: dessertCellIdentifier, for: indexPath) as! DessertCell
        cell.dessertNameLabel.text = dessertNames[indexPath.row]
        return cell
    }
    
    // function that populates the dessert list used to display in TableView
    func populateList() async throws -> [String:dessertInfo] {
        var results:[String:dessertInfo] = [:]
        // populate dessertList w/ meal name and dessert info
        // uses first url provided in iOS exercise handout to grab name, dessert id, and image
        print("entered here")
        let (data, _) = try await URLSession.shared.data(from: request!)
        let json = try? JSONSerialization.jsonObject(with: data)
        
        // parses through json file to update necessary dessert information
        if let meals = json as? [String: Any] {
            if let desserts = meals["meals"] as? [Any] {
                for dessert in desserts {
                    let tempInfo:[String] = getDessertInfo(currDessertInfo: dessert as! [String : String])
                    results[tempInfo[0]] = dessertInfo(dessertID: tempInfo[1], dessertImg: URL(string: tempInfo[2])!)
                }
            }
        }
        
        print("finished populating list")
        return results
    }
    
    // function that passes the dessert name, dessert id, and associated image to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChosenDessertInfoSegue", let nextVC = segue.destination as? DessertViewController {
            nextVC.delegate = self
            let selectedRow = dessertTableView.indexPathForSelectedRow?.row
            let currDessert = dessertList[dessertNames[selectedRow!]]
            // Note: the data is small enough to keep it a synchronous call; for larger data use an async call
            let data = try? Data(contentsOf: currDessert!.dessertImg)
            if let imageData = data {
                nextVC.dessertImg = UIImage(data: imageData)!
            }
            nextVC.dessertName = dessertNames[selectedRow!]
            nextVC.foodID = currDessert!.dessertID
        }
    }
    
    // helper function that returns the dessert name, id, and thumbnail img of each dessert
    func getDessertInfo(currDessertInfo:[String:String]) -> [String] {
        var thumbnailImg = ""
        var foodName = ""
        var foodID = ""
        // iterates through the dictionary keys to find the key terms
        for (key, value) in currDessertInfo {
            if (key == "strMealThumb") {
                thumbnailImg = value
            } else if (key == "strMeal") {
                foodName = value
            } else if (key == "idMeal") {
                foodID = value
            }
        }
        return [foodName, foodID, thumbnailImg]
    }

}

