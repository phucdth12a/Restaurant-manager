//
//  PreviewVC.swift
//  1542257-1542258
//
//  Created by Phu on 4/11/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

protocol PreviewControllerDelegate {
    func delete()
}

class PreviewVC: UIViewController {
    
    // MARK: *** Data model
    var image: UIImage?
    
    // MARK: *** UI Elements
    @IBOutlet weak var imagePreview: UIImageView!
    
    // MARK: *** Local variables
    var delegate: PreviewControllerDelegate?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePreview.image = image
        
        let deleteButton = UIBarButtonItem(title: NSLocalizedString("btnDelete", comment: ""), style: .done, target: self, action: #selector(deletebutton_Tapped))
        self.navigationItem.setRightBarButton(deleteButton, animated: true)
        
    }
    
    func deletebutton_Tapped() {
        delegate?.delete()
        _ = self.navigationController?.popViewController(animated: true)
    }
}
