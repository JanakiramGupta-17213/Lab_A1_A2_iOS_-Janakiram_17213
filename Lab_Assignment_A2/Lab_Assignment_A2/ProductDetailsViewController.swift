//
//  ProductDetailsViewController.swift
//  Lab_Assignment_A2
//
//  Created by Janakiram Gupta on 19/09/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productidTF: UITextField!
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var productPriceTF: UITextField!
    @IBOutlet weak var productProviderTF: UITextField!
    @IBOutlet weak var productDescLblTV: UITextView!
    
    @IBOutlet weak var cancelBut: UIButton!
    
    var flag = String()
    
    
    var details = Product()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isToolbarHidden = true
        
        if (flag == "Row") {
            cancelBut.isHidden = true
            productidTF.text = "\(details.productid)"
            productNameTF.text = details.productname
            productPriceTF.text = details.productprice
            productProviderTF.text = details.productprovider
            productDescLblTV.text = details.productdescription
        }

    }
    
    // action when save button is clicked
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let prodId: Int? = Int(productidTF.text!)
        createProductItem(productId: prodId!, productName: productNameTF.text!, productDescription: productDescLblTV.text!, productPrice: productPriceTF.text!, productProvider:  productProviderTF.text!)
    }
    
    // action when cancel button is clicked
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // creating a new product logic starts here
    func createProductItem(productId: Int, productName: String, productDescription: String, productPrice: String, productProvider: String) {
        
        let newProductItem = Product(context: context)
        newProductItem.productid = Int64(productId)
        newProductItem.productname = productName
        newProductItem.productprice = productPrice
        newProductItem.productprovider = productProvider
        newProductItem.productdescription = productDescription
        
        do {
            try context.save()
        } catch {
            //error
            print(error)
        }
        
        if (flag == "Row") {
            
        } else {
            NotificationCenter.default.post(name: .didReceiveData, object: nil)
            dismiss(animated: true, completion: nil)
        }
    }

}
