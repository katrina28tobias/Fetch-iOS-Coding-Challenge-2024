# Fetch-iOS-Coding-Challenge-2024
Goal: write a native iOS app that allows users to browse recipe using the given api from MealDB. This exercise focused on the category desserts.
Note for the reviewer: while the UIKit was used to construct the ViewControllers, some elements of SwiftUI were used to parse through the json file (more details below).

# ViewController.swift w/ main components
class DessertCell: used to display the name of the dessert

struct dessertInfo: contains dessertID and dessert image

main ViewController: displays the list of desserts in alphabetical order using a UITableView

func viewDidLoad(): asynchronous call to API is found here

func populateList(): asynchronous function that parses through the json file to find the dessert name, ID, and image. 

func prepare(): passes dessert name and image to DessertViewController; dessertID is used to update the second URL given in the exercise in order to obtain information regarding ingredients, measurements, and instructions

