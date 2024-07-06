//  DessertViewController.swift
//  TobiasK-Fetch-Coding-Challenge-2024-StoryboardVersion
//  Created by Katrina Tobias on 7/1/24.

import UIKit
import Foundation

// DessertViewController class that displays the name of the dessert, the ingredients w/ measurements, and directions
class DessertViewController: UIViewController {
    
    // struct that models the information found in the json file
    struct Meal: Codable {
        let idMeal: String?
        let strMeal: String?
        
        let strInstructions: String?
        let strIngredient1: String?
        let strIngredient2: String?
        let strIngredient3: String?
        let strIngredient4: String?
        let strIngredient5: String?
        let strIngredient6: String?
        let strIngredient7: String?
        let strIngredient8: String?
        let strIngredient9: String?
        let strIngredient10: String?
        let strIngredient11: String?
        let strIngredient12: String?
        let strIngredient13: String?
        let strIngredient14: String?
        let strIngredient15: String?
        let strIngredient16: String?
        let strIngredient17: String?
        let strIngredient18: String?
        let strIngredient19: String?
        let strIngredient20: String?
        
        let strMeasure1: String?
        let strMeasure2: String?
        let strMeasure3: String?
        let strMeasure4: String?
        let strMeasure5: String?
        let strMeasure6: String?
        let strMeasure7: String?
        let strMeasure8: String?
        let strMeasure9: String?
        let strMeasure10: String?
        let strMeasure11: String?
        let strMeasure12: String?
        let strMeasure13: String?
        let strMeasure14: String?
        let strMeasure15: String?
        let strMeasure16: String?
        let strMeasure17: String?
        let strMeasure18: String?
        let strMeasure19: String?
        let strMeasure20: String?
    }
    
    // struct used to decode the json file
    struct MealsResponse: Codable {
        let meals: [Meal]
    }
    
    // variables
    var delegate: ViewController?
    var dessertName: String = ""
    var foodID: String = ""
    var dessertImg: UIImage = UIImage(named: "hearts")!
    var request = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    var finalURL: URL?
    var ingredients:[String] = []
    var measurements:[String] = []
    var directions:[String] = []
    
    
    // outlets
    @IBOutlet weak var dessertNameLabel: UILabel!
    @IBOutlet weak var dessertImage: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsListTextView: UITextView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var directionsTextView: UITextView!
    
    // function that updates the text views of the ingredients and directions
    override func viewWillAppear(_ animated: Bool) {
        // updates url using the chosen food ID
        request = request + foodID
        finalURL = URL(string: request)
        print("URL: \(String(describing: finalURL))")
        dessertNameLabel.text = dessertName
        dessertImage.image = dessertImg
        
        // async call
        Task { @MainActor in
            let displayedInformation:[String] = try await updateRecipeAndIngredients()
            directionsTextView.text = displayedInformation[0]
            ingredientsListTextView.text = displayedInformation[1]
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // function that updates the recipe and ingredients (can be moved to other view controller)
    func updateRecipeAndIngredients() async throws -> [String] {
        var results:[String] = []
        
        // fetches data from URL
        let (data, _) = try await URLSession.shared.data(from: finalURL!)
        let decoder = JSONDecoder()
        let dessertsResponse = try decoder.decode(MealsResponse.self, from: data)
        if let dessert = dessertsResponse.meals.first {
            // fetches the instructions
            if let dessertInstructions = dessert.strInstructions {
                print("Instructions: \(dessertInstructions)")
                results.append(dessertInstructions)
            }
            // fetches the measurements and ingredients
            let ingredientsWithMeasurements = getIngredientsAndMeasurements(dessert: dessert)
            print("Ingredients w/ measurements: \(ingredientsWithMeasurements)")
            results.append(ingredientsWithMeasurements)
            
        }
        
        return results
    }
    
    // helper function to associate the right measurement for each ingredient
    func getIngredientsAndMeasurements(dessert: Meal) -> String {
        var finalCombo:[String] = []
        // key variables used to iterate through the list and match the ingredient with the measurements
        let ingredientKeys = [dessert.strIngredient1, dessert.strIngredient2, dessert.strIngredient3, dessert.strIngredient4, dessert.strIngredient5, dessert.strIngredient6, dessert.strIngredient7, dessert.strIngredient8, dessert.strIngredient9, dessert.strIngredient10, dessert.strIngredient11, dessert.strIngredient12, dessert.strIngredient13, dessert.strIngredient14, dessert.strIngredient15, dessert.strIngredient16, dessert.strIngredient17, dessert.strIngredient18, dessert.strIngredient19, dessert.strIngredient20]
        let measurementKeys = [dessert.strMeasure1, dessert.strMeasure2, dessert.strMeasure3, dessert.strMeasure4, dessert.strMeasure5, dessert.strMeasure6, dessert.strMeasure7, dessert.strMeasure8, dessert.strMeasure9, dessert.strMeasure10, dessert.strMeasure11, dessert.strMeasure12, dessert.strMeasure13, dessert.strMeasure14, dessert.strMeasure15, dessert.strMeasure16, dessert.strMeasure17, dessert.strMeasure18, dessert.strMeasure19, dessert.strMeasure20]
        
        for (measurement, ingredient) in zip(measurementKeys, ingredientKeys) {
            // condition to make sure the value is not null nor empty (the filtering component to the exercise)
            if !(measurement!.isEmpty) && !(ingredient!.isEmpty) && (measurement != nil) && (ingredient != nil) {
                let combo = measurement! + " " + ingredient!
                finalCombo.append(combo)
            }
        }
        
        // allows ingredients in text view to appear as a list
        let jointCombo = finalCombo.joined(separator: "\n")
        return jointCombo
    }

}
