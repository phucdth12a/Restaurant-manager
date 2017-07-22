//
//  ChooseFoodVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/17/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

struct orderFood {

    var food: Food
    var order: Order
}

enum selectedScope: Int {
    case all = 0
    case food = 1
    case drink = 2
}

class ChooseFoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    // MARK: *** UI Events
    @IBAction func btnAddFood_Tapped(_ sender: UIButton) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for selectedRow in selectedRows {
                
                let selectedCell = self.tableView.cellForRow(at: selectedRow) as! ChooseFoodCell
            
                if selectedCell.txtNumberFood.isEmpty() {
                    alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_numberOrder", comment: ""))
                    return;
                }
            }

        }
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            for selectedRow in selectedRows {
                var flag = true

                let selectedCell = self.tableView.cellForRow(at: selectedRow) as! ChooseFoodCell
                let number: Int = Int(selectedCell.txtNumberFood.text!)!
                let food = foods[selectedRow.section][selectedRow.row]
                let newNumber = Order.create() as! Order
                newNumber.number = Int16(number)
                let newOrder = orderFood(food: food, order: newNumber)
                
                for dt in data {
                    if dt.food == food {
                        
                        //let listorderFood = food.toOrders?.allObjects as! [Order]
                        let listorderTable = table?.toOrders?.allObjects as! [Order]
                        
                        if let index = listorderTable.index(of: dt.order) {
                            listorderTable[index].number += Int16(number)
                            DB.MOC.delete(newNumber)
                            DB.save()
                        }

                        flag = false
                        break
                    }
                }
                
                if flag == true {
                    table?.addToToFoods(foods[selectedRow.section][selectedRow.row])
                    
                    table?.addToToOrders(newNumber)
                    food.addToToOrders(newNumber)
                    
                    DB.save()
                    
                    data.append(newOrder)
                }
                
            }
        }
        
        delegate?.doneOrder()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: *** Data model
    var foods = [[Food]]()
    var table: Table?
    var foodOrder = [Food]()
    var data = [orderFood]()
    var delegate: OrderControllerDelegate?
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        let foodTypeFood = Food.getFoods(by: true)
        let foodTypeDrink = Food.getFoods(by: false)
        
        foods.append(foodTypeFood)
        foods.append(foodTypeDrink)
        
        btnAdd.setTitle(NSLocalizedString("btnAdd", comment: ""), for: .normal)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        
        foodOrder = table?.toFoods?.allObjects as! [Food]
        
        for food in foodOrder {
            let listorderFood = food.toOrders?.allObjects as! [Order]
            let listorderTable = table?.toOrders?.allObjects as! [Order]
            
            for order in listorderFood {
                if let _ = listorderTable.index(of: order) {
                    let orderNewFood = orderFood(food: food, order: order)
                    data.append(orderNewFood)
                    break
                }
            }
        }

        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        self.searchBarSetup()
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        //mainScrollView.isScrollEnabled = true
        // Lay thong tin ban phim
        let info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        // Thay doi content inset de scroll duoc
        var contentInset: UIEdgeInsets = self.mainScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.mainScrollView.contentInset = contentInset
        self.mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // Thay doi content inset de scroll duoc
        var contentInset = UIEdgeInsets.zero
        contentInset.top = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height
        self.mainScrollView.contentInset = contentInset
        self.mainScrollView.scrollIndicatorInsets = contentInset
    }


    // MARK: *** UITableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if buttonSearchBarSelected == 0 {
            if section == 0 {
                return NSLocalizedString("foodTypeFood", comment: "")
            } else {
                return NSLocalizedString("foodTypeDrink", comment: "")
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        if (title == "") {
            return 0.0
        }
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let food = foods[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseFoodCell", for: indexPath) as! ChooseFoodCell
        cell.lblNameFood.text = food.name
        let price: Double = food.price
        cell.lblPriceFood.text = "\(price)$"
        cell.txtNumberFood.placeholder = NSLocalizedString("inputNumber", comment: "")
        
        addDoneButton(to: cell.txtNumberFood)
        
        let foodImage = food.toImages?.allObjects as! Array<Image>
        if foodImage.count > 0 {
            cell.imageFood.image = UIImage(data: foodImage[0].data! as Data)
        }
        
        return cell
    }
    
    // MARK: *** SearchBar
    var buttonSearchBarSelected = 0
    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["All", "Food", "Drink"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        buttonSearchBarSelected = searchBar.selectedScopeButtonIndex
        filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        buttonSearchBarSelected = searchBar.selectedScopeButtonIndex
        filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchBar.text!)
    }
    
    func filterTableView(ind: Int, text: String) {
        switch ind {
        case selectedScope.all.rawValue:
            
            foods.removeAll()
            if text.isEmpty {
                foods.removeAll()
                let foodTypeFood = Food.getFoods(by: true)
                let foodTypeDrink = Food.getFoods(by: false)
                
                foods.append(foodTypeFood)
                foods.append(foodTypeDrink)
                self.tableView.reloadData()
            } else {
                let foodTypeFood = Food.getFoods(by: true)
                let foodTypeDrink = Food.getFoods(by: false)
                
                for food in foodTypeFood {
                    if (food.name?.lowercased().contains(text.lowercased()))! {
                        if foods.count == 1 {
                            foods[0].append(food)
                        } else {
                            foods.append([food])
                        }
                    }
                }
                
                for food in foodTypeDrink {
                    if (food.name?.lowercased().contains(text.lowercased()))! {
                        if foods.count == 2 {
                            foods[1].append(food)
                        } else {
                            foods.append([food])
                        }
                    }
                }
                self.tableView.reloadData()
            }
        case selectedScope.food.rawValue:
            
            foods.removeAll()
            if text.isEmpty {
                foods.removeAll()
                let foodTypeFood = Food.getFoods(by: true)
                foods.append(foodTypeFood)
                self.tableView.reloadData()
            } else {
                let foodTypeFood = Food.getFoods(by: true)
                
                for food in foodTypeFood {
                    if (food.name?.lowercased().contains(text.lowercased()))! {
                        if foods.count == 1 {
                            foods[0].append(food)
                        } else {
                            foods.append([food])
                        }
                    }
                }
                self.tableView.reloadData()
            }
        case selectedScope.drink.rawValue:
                
            foods.removeAll()
            if text.isEmpty {
                foods.removeAll()
                
                let foodTypeDrink = Food.getFoods(by: false)
                
                foods.append(foodTypeDrink)
                self.tableView.reloadData()
            } else {
                
                let foodTypeDrink = Food.getFoods(by: false)
                
                for food in foodTypeDrink {
                    if (food.name?.lowercased().contains(text.lowercased()))! {
                        if foods.count == 2 {
                            foods[1].append(food)
                        } else {
                            foods.append([food])
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        default:
            print("No type")
        }
    }

}
