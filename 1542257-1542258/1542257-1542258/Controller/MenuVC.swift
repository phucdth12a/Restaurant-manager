//
//  MenuVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var iconLogo: UIImageView!
    
    var iconArray = [UIImage]()
    var menuNameArray = [String]()
    var home: String = ""
    var table: String = ""
    var counter: String = ""
    var food: String = ""
    var currency: String = ""
    var statistical: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        home = NSLocalizedString("menu_home", comment: "")
        table = NSLocalizedString("menu_table", comment: "")
        counter = NSLocalizedString("menu_counter", comment: "")
        food = NSLocalizedString("menu_food", comment: "")
        currency = NSLocalizedString("menu_currency", comment: "")
        statistical = NSLocalizedString("menu_statistical", comment: "")
        
        menuNameArray = [home, table, counter, food, currency, statistical]
        iconArray = [UIImage(named: "home")!, UIImage(named: "Table")!, UIImage(named: "Counter")!, UIImage(named: "Food")!, UIImage(named: "Currency")!, UIImage(named: "Chart")!]
        
        iconLogo.layer.borderWidth = 2
        iconLogo.layer.borderColor = UIColor.green.cgColor
        iconLogo.layer.cornerRadius = 50
        iconLogo.layer.masksToBounds = false
        iconLogo.clipsToBounds = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.iconImage.image = iconArray[indexPath.row]
        cell.lblMenuName.text! = menuNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewController: SWRevealViewController = self.revealViewController()
        
        let cell: MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        
        if cell.lblMenuName.text! == home {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuName.text! == counter {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "CounterVC") as! CounterVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuName.text! == food {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "FoodVC") as! FoodVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuName.text! == currency {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "CurrencyVC") as! CurrencyVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuName.text! == statistical {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "StatisticalVC") as! StatisticalVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.lblMenuName.text! == table {
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "TableVC") as! TableVC
            let newFrontController = UINavigationController.init(rootViewController: newViewController)
            
            revealviewController.pushFrontViewController(newFrontController, animated: true)
        }
        
    }

}
