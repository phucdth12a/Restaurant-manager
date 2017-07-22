//
//  DetailFoodVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/11/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit


class DetailFoodVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, PreviewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: *** Local varialbles
    var delegate: FoodControllerDelegate?
    
    // MARK: *** UI Elements
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let imagePicker = UIImagePickerController()
    let typePickerView = UIPickerView()
    
    // MARK: *** Data model
    var model = ""
    var food: Food?
    let types = [NSLocalizedString("foodTypeFood", comment: ""), NSLocalizedString("foodTypeDrink", comment: "")]
    
    // MARK: *** UI Events
    @IBAction func addImage_Tapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButton(tos: [txtName, txtPrice])
        addDoneButton(textViewDescription)

        lblName.text = NSLocalizedString("lblName", comment: "")
        lblDescription.text = NSLocalizedString("lblDescription", comment: "")
        lblImages.text = NSLocalizedString("lblImages", comment: "")
        btnAdd.setTitle(NSLocalizedString("btnAdd", comment: ""), for: .normal)
        lblType.text = NSLocalizedString("lblType", comment: "")
        lblPrice.text = NSLocalizedString("lblPrice", comment: "")
        
        textViewDescription.layer.borderWidth = 1
        textViewDescription.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewDescription.layer.cornerRadius = 6
        textViewDescription.layer.masksToBounds = false
        textViewDescription.clipsToBounds = true
        
        imagePicker.delegate = self
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        self.txtPrice.delegate = self
        
        // khi tap vao txtType show pickerview
        typePickerView.delegate = self
        typePickerView.dataSource = self
        txtType.inputView = typePickerView
        
        if model == "Add" {
            self.title = NSLocalizedString("titleAddFood", comment: "")
            let addButton = UIBarButtonItem(title: NSLocalizedString("btnAdd", comment: ""), style: .done, target: self, action: #selector(addFood_Tapped))
            self.navigationItem.setRightBarButton(addButton, animated: true)
            textViewDescription.text = ""
            txtType.text = types[0]
        } else if model == "Edit" {
            self.title = NSLocalizedString("titleEditFood", comment: "")
            let editButton = UIBarButtonItem(title: NSLocalizedString("btnEdit", comment: ""), style: .done, target: self, action: #selector(editFood_Tapped))
            self.navigationItem.setRightBarButton(editButton, animated: true)
            loadData()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
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

    
    func addFood_Tapped() {
        if txtName.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_nameFood", comment: ""))
        } else if textViewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionFood", comment: ""))
        } else if txtPrice.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_priceFood", comment: ""))
        } else {
            let newFood = Food.create() as! Food
            
            newFood.name = txtName.text
            newFood.describe = textViewDescription.text
            if txtType.text == NSLocalizedString("foodTypeFood", comment: "") {
                newFood.type = true
            } else {
                newFood.type = false
            }
            
            newFood.price = Double(txtPrice.text!)!
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                newFood.addToToImages(image)
            }
            
            DB.save()
            delegate?.addFood(newFood: newFood)
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_addFood", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func editFood_Tapped() {
        if txtName.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_nameFood", comment: ""))
        } else if textViewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionFood", comment: ""))
        } else if txtPrice.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_priceFood", comment: ""))
        } else {
            food?.name = txtName.text
            food?.describe = textViewDescription.text
            if txtType.text == NSLocalizedString("foodTypeFood", comment: "") {
                food?.type = true
            } else {
                food?.type = false
            }
            
            food?.price = Double(txtPrice.text!)!
            
            // xoa het image truoc do
            for item in (food?.toImages)! {
                let image = item as! Image
                food?.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                food?.addToToImages(image)
            }
            
            DB.save()
            delegate?.editFood()
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_editFood", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func loadData() {
        txtName.text = food?.name
        textViewDescription.text = food?.describe
        let price: Double = (food?.price)!
        txtPrice.text = String(price)
        
        if food?.type == true {
            typePickerView.selectRow(0, inComponent: 0, animated: false)
            txtType.text = types[0]
        } else {
            print(1232)
            typePickerView.selectRow(1, inComponent: 0, animated: false)
            txtType.text = types[1]
        }
        
        for item in (food?.toImages)! {
            let image = item as! Image
            addImageTo(scroll: scrollView, image: UIImage(data: image.data! as Data)!)
        }
        
    }
    
    //MARK: *** UIPickerView
    var selectedImageQueue = [UIImage]()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImageTo(scroll: scrollView, image: pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addImageTo(scroll: UIScrollView, image: UIImage) {
        
        selectedImageQueue += [image]
        
        let width = CGFloat(100)
        let height = CGFloat(100)
        let spacing = CGFloat(10)
        
        let size = scroll.contentSize
        var count = CGFloat(0)
        
        if size.width > 0 {
            count = (size.width - spacing) / (width + spacing)
        }
        
        let img = UIImageView(frame: CGRect(x: spacing + (width + spacing) * count, y: 10, width: width, height: height))
        img.image = image
        
        img.tag = Int(count)
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage_Tapped(_:)))
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        
        scroll.addSubview(img)
        
        count += 1
        scroll.contentSize = CGSize(width: spacing + (width + spacing) * CGFloat(count), height: height)
    }
    
    func reloadImageTo(scroll: UIScrollView, image: UIImage) {
        let width = CGFloat(100)
        let height = CGFloat(100)
        let spacing = CGFloat(10)
        
        let size = scroll.contentSize
        var count = CGFloat(0)
        
        if size.width > 0 {
            count = (size.width - spacing) / (width + spacing)
        }
        
        let img = UIImageView(frame: CGRect(x: spacing + (width + spacing) * count, y: 10, width: width, height: height))
        img.image = image
        
        img.tag = Int(count)
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage_Tapped(_:)))
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        
        scroll.addSubview(img)
        
        count += 1
        scroll.contentSize = CGSize(width: spacing + (width + spacing) * CGFloat(count), height: height)
    }
    
    var selectedIndex = -1
    
    func previewImage_Tapped(_ sender: UITapGestureRecognizer) {
        self.selectedIndex = (sender.view?.tag)!
        performSegue(withIdentifier: "ImagePreviewID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImagePreviewID" {
            let image = selectedImageQueue[selectedIndex]
            
            let dest = segue.destination as! PreviewVC
            dest.image = image
            dest.delegate = self
        }
    }
    
    // MARK: *** PreviewControllerDelegate
    func delete() {
        
        if let images = food?.toImages?.allObjects {
            if images.count <= self.selectedIndex {
                let image = images[self.selectedIndex] as! Image
                
                food?.removeFromToImages(image)
            }
        }
        
        selectedImageQueue.remove(at: self.selectedIndex)
        
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        self.scrollView.contentSize.width = 0
        for reImage in selectedImageQueue {
            reloadImageTo(scroll: scrollView, image: reImage)
        }
        
        DB.save()
        
    }
    
    // MARK: *** UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtType.text = types[row]
        
        self.view.endEditing(true)
    }

}
