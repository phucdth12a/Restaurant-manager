//
//  FoodVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

protocol FoodControllerDelegate {
    func addFood(newFood: Food)
    func editFood()
}

class FoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FoodControllerDelegate {
    
    // MARK: *** Data model 
    var foods = [[Food]]()
    
    // MARK: *** UI Elements
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("titleFood", comment: "")

        if revealViewController() != nil {
            btnMenu.target = revealViewController()
            btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        let foodTypeFood = Food.getFoods(by: true)
        let foodTypeDrink = Food.getFoods(by: false)
        
        foods.append(foodTypeFood)
        foods.append(foodTypeDrink)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewFoodID" {
            let dest = segue.destination as! DetailFoodVC
            dest.model = "Add"
            dest.delegate = self
        } else if segue.identifier == "EditFoodID" {
            let dest = segue.destination as! DetailFoodVC
            dest.model = "Edit"
            dest.food = selectedFood
            dest.delegate = self
        }
    }
    
    
    // MARK: *** UITableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("foodTypeFood", comment: "")
        } else {
            return NSLocalizedString("foodTypeDrink", comment: "")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let food = foods[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        cell.txtNameFood.text = food.name
        cell.txtDescriptionFood.text = food.describe
        
        let foodImage = food.toImages?.allObjects as! Array<Image>
        if foodImage.count > 0 {
            cell.imageFood.image = UIImage(data: foodImage[0].data! as Data)
        }
        return cell
    }
    
    var selectedFood: Food?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFood = foods[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "EditFoodID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let food = foods[indexPath.section][indexPath.row]
            
            for item in food.toImages! {
                let image = item as! Image
                food.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            DB.MOC.delete(food)
            foods[indexPath.section].remove(at: indexPath.row)
            
            DB.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: *** FoodControllerDelegae
    func addFood(newFood: Food) {
        if newFood.type == true {
            foods[0] += [newFood]
        } else {
            foods[1] += [newFood]
        }
    }
    
    func editFood() {
        
        foods.removeAll()
        
        let foodTypeFood = Food.getFoods(by: true)
        let foodTypeDrink = Food.getFoods(by: false)
        
        foods.append(foodTypeFood)
        foods.append(foodTypeDrink)
    }

}
