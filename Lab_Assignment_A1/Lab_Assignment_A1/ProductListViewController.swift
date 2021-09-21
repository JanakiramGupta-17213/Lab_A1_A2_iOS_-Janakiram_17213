//
//  ViewController.swift
//  Lab_Assignment_A1
//
//  Created by Janakiram Gupta on 19/09/21.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    private var productsData = [Product]()
    var filteredProducts: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        // Search Controller //
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Type here to search products")
        
        searchController.searchBar.tintColor = UIColor.black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        checkExitData()
        filteredProducts = productsData
    
    }
    
    func checkExitData() {
        do {
            productsData = try context.fetch(Product.fetchRequest())
            if (productsData.count == 0) {
                addProductData()
            } else {
                getAllItems()
            }
        } catch {
            //error
            print(error)
        }
    }
    
    //Core Data starts here
    func getAllItems() {
        do {
            productsData = try context.fetch(Product.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
            print(error)
        }
    }
    
    // creating item logic starts here
    func createProductItem(productId: Int, productName: String, productDescription: String, productPrice: String, productProvider: String) {
        
        let newProductItem = Product(context: context)
        newProductItem.productid = Int64(productId)
        newProductItem.productname = productName
        newProductItem.productprice = productPrice
        newProductItem.productprovider = productProvider
        newProductItem.productdescription = productDescription
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
            print(error)
        }
    }
    
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = filteredProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(product.productname!)"
        cell.detailTextLabel?.text = "Price: $\(product.productprice!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = filteredProducts[indexPath.row]
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.details = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Adding Dummy data for displaying product details
    func addProductData()  {
        
        createProductItem(productId: 1, productName: "Brazilian Dry Oil", productDescription: "Brazilian Dry Oil is a fast-absorbing, lightweight oil that can be used daily to smooth", productPrice: "26.00", productProvider: "Brazilian")
        createProductItem(productId: 2, productName: "Ionic Color Lock", productDescription: " Lock in week one color vibrancy for all shades, colors, and blonde tones.", productPrice: "38.00", productProvider: "Ionic")
        createProductItem(productId: 3, productName: "Professional Styling", productDescription: "Smooth or style with this versatile, lightweight, ergonomic styling iron. Far infrared heat penetra", productPrice: "175.00", productProvider: "Professional")
        createProductItem(productId: 4, productName: "Hydrate Conditioning Masque", productDescription: "AVOCADO OILAmong the healthiest natural ingredients on the planet, avocado oil is beneficial for hai", productPrice: "20.00", productProvider: "Hydrate")
        createProductItem(productId: 5, productName: "Smooth Conditioner", productDescription: "AVOCADO OILAmong the healthiest natural ingredients on the planet, avocado oil is beneficial for hai", productPrice: "20.00", productProvider: "Smooth Conditioner")
        
        createProductItem(productId: 6, productName: "Clean Shampoo", productDescription: "AVOCADO OILAmong the healthiest natural ingredients on the planet, avocado oil is beneficial for hai..", productPrice: "50.00", productProvider: "Clean Shampoo")
        createProductItem(productId: 7, productName: "Instant Damage Correction Shampoo", productDescription: "The exclusive LEAF & FLOWER CBD Corrective Complex elicits an entourage effect by combining key cann..", productPrice: "37.00", productProvider: "Correction Shampoo")
        createProductItem(productId: 8, productName: "SPECIAL SHAMPOO ", productDescription: "Special ingredients and tea tree oil rid hair of impurities and leave hair full of vitality and lust..", productPrice: "15.00", productProvider: "SPECIAL SHAMPOO")
        createProductItem(productId: 9, productName: "MOISTURE SHAMPOO", productDescription: " Nourish tresses with lightweight moisture while gently cleansing. This breakthrough formula envelo..", productPrice: "50.00", productProvider: "MOISTURE SHAMPOO")
        createProductItem(productId: 10, productName: "Bombshell Shine Mist", productDescription: "Steal the spotlight in an instant with this weightless, superfine mist. Provides frizz and flyaway .", productPrice: "10.00", productProvider: "Bombshell Shine Mist")
    }
}

extension ProductListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // if didn't typed anything in the search input field then don't filter results
        if searchController.searchBar.text! == "" {
            filteredProducts = productsData
        } else {
        // Filter the results
            filteredProducts = productsData.filter { $0.productname!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        self.tableView.reloadData()
    }
   
}

