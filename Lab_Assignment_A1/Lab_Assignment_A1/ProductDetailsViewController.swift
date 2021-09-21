//
//  ProductDetailsViewController.swift
//  Lab_Assignment_A1
//
//  Created by Janakiram Gupta on 19/09/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var prodIDLbl: UILabel!
    @IBOutlet weak var prodNameLbl: UILabel!
    @IBOutlet weak var prodPriceLbl: UILabel!
    @IBOutlet weak var prodProviderLbl: UILabel!
    @IBOutlet weak var prodDescLbl: UILabel!
    
    var details = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Product Details"
        let nextLine = "\n"
        prodIDLbl.text = "Product ID: \(details.productid)"
        prodNameLbl.text = "Product Name: \(details.productname!)"
        prodProviderLbl.text = "Product Provider: \(details.productprovider!)"
        prodPriceLbl.text = "Product Price: $ \(details.productprice!)"
        prodDescLbl.text = "Product Description: \(nextLine) \(details.productdescription!)"
    }

}
