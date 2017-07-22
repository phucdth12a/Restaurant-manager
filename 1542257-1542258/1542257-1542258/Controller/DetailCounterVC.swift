//
//  DetailCounterVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/10/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class DetailCounterVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PreviewControllerDelegate {

    // MARK: *** Local variables
    var delegate: CounterControllerDelegate?
    
    // MARK: *** UI Elements
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    let imagePicker = UIImagePickerController()
    
    // MARK: *** Data model
    var model = ""
    var counter: Counter?
    
    // MARK: *** UI Events
    @IBAction func addImage_Tapped(_ sender: UIButton) {
        present(imagePicker, animated:  true)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblName.text = NSLocalizedString("lblName", comment: "")
        lblDescription.text = NSLocalizedString("lblDescription", comment: "")
        lblImage.text = NSLocalizedString("lblImages", comment: "")
        btnAdd.setTitle(NSLocalizedString("btnAdd", comment: ""), for: .normal)
        
        textviewDescription.layer.borderWidth = 1
        textviewDescription.layer.borderColor = UIColor(displayP3Red: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textviewDescription.layer.cornerRadius = 6
        textviewDescription.layer.masksToBounds = false
        textviewDescription.clipsToBounds = true
        
        addDoneButton(to: txtName)
        addDoneButton(textviewDescription)
        
        if model == "Add" {
            self.title = NSLocalizedString("titleAddCounter", comment: "")
            let addButton = UIBarButtonItem(title: NSLocalizedString("btnAdd", comment: ""), style: .done, target: self, action: #selector(addCounter_Tapped))
            self.navigationItem.setRightBarButton(addButton, animated: true)
            textviewDescription.text = ""
        } else if model == "Edit" {
            self.title = NSLocalizedString("titleEditCounter", comment: "")
            let editButton = UIBarButtonItem(title: NSLocalizedString("btnEdit", comment: ""), style: .done, target: self, action: #selector(editCounter_Tapped))
            self.navigationItem.setRightBarButton(editButton, animated: true)
            loadData()
        }
        
        imagePicker.delegate = self
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
      
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
    
    
    func addCounter_Tapped() {
        if txtName.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_nameCounter", comment: ""))
        } else if textviewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionCounter", comment: ""))
        } else {
            let newCounter = Counter.create() as! Counter
            
            newCounter.name = txtName.text
            newCounter.describe = textviewDescription.text
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                newCounter.addToToImages(image)
            }
            
            DB.save()
            delegate?.addCounter(newCounter: newCounter)
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_addCounter", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
    
    func loadData() {
        txtName.text = counter?.name
        textviewDescription.text = counter?.describe
        
        for item in (counter?.toImages)! {
            let image = item as! Image
            addImageTo(scroll: scrollView, image: UIImage(data: image.data! as Data)!)
        }
    }
    
    func editCounter_Tapped() {
        if txtName.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_nameCounter", comment: ""))
        } else if textviewDescription.isEmpty() {
            alert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_empty_descriptionCounter", comment: ""))
        } else {
            counter?.name = txtName.text
            counter?.describe = textviewDescription.text
            
            // Xoa het image trc do 
            for item in (counter?.toImages)! {
                let image = item as! Image
                counter?.removeFromToImages(image)
                DB.MOC.delete(image)
            }
            
            for selectedImage in selectedImageQueue {
                let image = Image.create() as! Image
                image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
                counter?.addToToImages(image)
            }
            
            DB.save()
            
            alert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("success_editCounter", comment: ""), handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
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
        
        if let images = counter?.toImages?.allObjects {
            if images.count <= self.selectedIndex {
                let image = images[self.selectedIndex] as! Image
                
                counter?.removeFromToImages(image)
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

}
