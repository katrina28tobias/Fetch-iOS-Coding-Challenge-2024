# Fetch-iOS-Coding-Challenge-2024
Goal: write a native iOS app that allows users to browse recipe using the given api from MealDB. This exercise focused on the desserts category.

# ViewController.swift w/ Main Components
class DessertCell: used to display the name of the dessert

struct dessertInfo: contains dessertID and dessert image

main ViewController: displays the list of desserts in alphabetical order using a UITableView

func viewDidLoad(): asynchronous call to API is found here

func populateList(): asynchronous function that parses through the json file to find the dessert name, ID, and image. 

func prepare(): passes dessert name and image to DessertViewController; dessertID is used to update the second URL given in the exercise in order to obtain information regarding ingredients, measurements, and instructions

# DessertViewController.swift w/ Main Components
struct Meal: coded using SwiftUI in order to parse through the json file easier (since the json file contains null/empty values)

struct MealsResponse: coded using SwiftUI to decode the given json file

func viewWillAppear(): used to update the textViews of the screen; since the recipes varied by what the user chooses in the table view, viewWillAppear would be the best function to use in order to update the data (since the text constantly changes with the recipes chosen). This is because viewDidLoad() only loads once; asynchronous call is done here

func updateRecipeAndIngredients: asynchronous function that fetches the data given the url and food id. Information is appended into a String array in the following order: [Dessert Directions, Dessert Measurements and Ingredients]. 

func getIngredientsAndMeasurements(): helper function that combines the correct ingredient with its correct measurement; filtering component of the exercise is done here by checking if the value is empty/null; returns a string separated by "\n" to display the ingredients in a list-like form.

# Final Note for the Reviewer:
While the UIKit was used to construct the ViewControllers, some elements of SwiftUI were used to parse through the json file. For more details on code, see swift files (they are commented!).
