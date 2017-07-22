//
//  DetailTableVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/14/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import CoreData

class DetailTableVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, PreviewControllerDelegate {
    
    // MARK: *** Local variables
    var delegate: TableControllerDelegate?
    
    // MARK: *** UI Elements
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var lblNumberOfTable: UILabel!
    @IBOutlet weak var txtNumberOfTable: UITextField!
    @IBOutlet weak var lblDescriptionTable: UILabel!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var txtCounter: UITextField!
    
    let imagePicker = UIImagePickerController()
    let counterPickerView = UIPickerView()
    
    // MARK: ** Data model
    var model = ""
    var table: Table?
    var counters = [Counter]()
    
    // MARL: *** UI Events
    @IBAction func addImage_Tapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        

        counters = Counter.all() as! [Counter]
        
        if counters.count == 0 {
            alert(title: NSLocalizedString("alertOpenTable", comment: ""), message: NSLocalizedString("emptyCounter", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
        
        if counters.count > 0 {
            addDoneButton(textviewDescription)
            addDoneButton(to: txtNumberOfTable)
            
            lblNumberOfTable.text = NSLocalizedString("lblNumberOfTable", comment: "")
            lblDescriptionTable.text = NSLocalizedString("lblDescription", comment: "")
            lblCounter.text = NSLocalizedString("titleCounter", comment: "")
            lblImages.text = NSLocalizedString("lblImages", comment: "")
            btnAdd.setTitle(NSLocalizedString("btnAdd", comment: ""), for: .normal)
            
            textviewDescription.layer.borderWidth = 1
            textviewDescription.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
            textviewDescription.layer.cornerRadius = 6
            textviewDescription.layer.masksToBounds = false
            textviewDescription.clipsToBounds = true
            
            imagePicker.delegate = self
            
            counterPickerView.delegate = self
            counterPickerView.dataSource = self
            txtCounter.inputView = counterPickerView
            
            // Dang ky xu ly su kien lien quan den ban phim
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
            
            if model == "Add" {
                self.title = NSLocalizedString("titleAddTable", comment: "")
                let addButton = UIBarButtonItem(title: NSLocalizedString("btnAdd", comment: ""), style: .done, target: self, action: #selector(addTable_Tapped))
                self.navigationItem.setRightBarButton(addButton, animated: true)
                txtCounter.text = counters[0].name
                textviewDescription.text = ""
                selectedCounter = counters[0]
            } else if model == "Edit" {
                self.title = NSLocalizedString("titleEditTable", comment: "")
                let editButton = UIBarButtonItem(title: NSLocalizedString("btnEdit", comment: ""), style: .done, target: self, action: #selector(editTable_Tapped))
                self.navigationItem.setRightBarButton(editButton, animated: true)
                loadData()
            }
        }

    }
    
    func addTable_Tapped() {
        if txtNumberOfTable.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_numberOfTable", comment: ""))
        } else if textviewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionTable", comment: ""))
        } else {
            let newTable = Table.create() as! Table
            
            newTable.number = Int16(txtNumberOfTable.text!)!
            newTable.infomation = textviewDescription.text
            newTable.status = false
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                newTable.addToToImages(image)
            }
            
            selectedCounter?.addToToTables(newTable)
            
            DB.save()
            delegate?.doneTable()
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_addTable", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func editTable_Tapped() {
        if txtNumberOfTable.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_numberOfTable", comment: ""))
        } else if textviewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionTable", comment: ""))
        } else {
            
            table?.number = Int16(txtNumberOfTable.text!)!
            table?.infomation = textviewDescription.text
            
            // Xoa het image trc do
            for item in (table?.toImages)! {
                let image = item as! Image
                table?.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                table?.addToToImages(image)
            }
            
            table?.toCounter?.removeFromToTables(table!)
            
            selectedCounter?.addToToTables(table!)
            
            DB.save()
            delegate?.doneTable()
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_editTable", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }

    }
    
    func loadData() {
        let number: Int16 = (table?.number)!
        txtNumberOfTable.text = String(number)
        textviewDescription.text = table?.infomation
        txtCounter.text = table?.toCounter?.name
        
        if let counterName = table?.toCounter?.name {
            
            var index = 0
            repeat {
                let counter = counters[index]
                if counterName == counter.name {
                    counterPickerView.selectRow(index, inComponent: 0, animated: false)
                    break
                }
                index += 1
            } while (index < counters.count)
        }
        
        for item in (table?.toImages)! {
            let image = item as! Image
            addImageTo(scroll: scrollView, image: UIImage(data: image.data! as Data)!)
        }
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
        
        if let images = table?.toImages?.allObjects {
            if images.count <= self.selectedIndex {
                let image = images[self.selectedIndex] as! Image
                
                table?.removeFromToImages(image)
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
        return counters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return counters[row].name
    }
    
    var selectedCounter: Counter?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCounter.text = counters[row].name
        selectedCounter = counters[row]
        self.view.endEditing(true)
    }

}
