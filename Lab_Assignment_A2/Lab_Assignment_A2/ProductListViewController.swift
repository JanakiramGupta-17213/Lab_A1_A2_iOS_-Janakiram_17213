//
//  ViewController.swift
//  Lab_Assignment_A2
//
//  Created by Janakiram Gupta on 19/09/21.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    private var productData = [Product]()
    var filteredCandies: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(editButtonPressed))
        
         // Search Controller
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Type here to search products")
        
        searchController.searchBar.tintColor = UIColor.black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationController?.isToolbarHidden = false
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(title: "Show Providers", style: UIBarButtonItem.Style.done, target: self, action: #selector(providerButtonPressed))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        )
        toolbarItems = items
        UINavigationBar.appearance().barTintColor = UIColor.black
                
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        getAllItems()
    }
    
    @objc private func providerButtonPressed() {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductProviderListVC") as! ProductProviderListVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func addButtonPressed() {
     
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.flag = "Add"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        self.navigationController?.isToolbarHidden = false
        getAllItems()
    }
    
    // action when editing a product is clicked
    @objc private func editButtonPressed() {

            navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonPressed))
            tableView.isEditing = true
    }
    
    // saving the product details
    @objc private func doneButtonPressed() {
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(editButtonPressed))
            tableView.isEditing = false
    }
    //Core Data
    func getAllItems() {
        do {
            productData = try context.fetch(Product.fetchRequest())
            
            DispatchQueue.main.async {
                self.filteredCandies = self.productData
                self.tableView.reloadData()
            }
        } catch {
            //error
            print(error)
        }
    }
    
    // deleting item logic starts here
    func deleteItem(item: Product) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
            print(error)
        }
    }
    
    func createProductItem(productId: Int, productName: String, productDescription: String, productPrice: String, productProvider: String) {
        
        let newItem = Product(context: context)
        newItem.productid = Int64(productId)
        newItem.productname = productName
        newItem.productprice = productPrice
        newItem.productprovider = productProvider
        newItem.productdescription = productDescription
        
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
        return filteredCandies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = filteredCandies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(product.productname!)"
        cell.detailTextLabel?.text = "\(product.productprovider!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = filteredCandies[indexPath.row]
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.details = item
        vc.flag = "Row"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the specified item to be editable.
           return true
       }
    

    
       // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
            let item = filteredCandies[indexPath.row]
            deleteItem(item: item)
               // Delete the row from the data source
            //   tableView.deleteRows(at: [indexPath], with: .fade)
            
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
}

extension ProductListViewController: UISearchResultsUpdating {
    

    func updateSearchResults(for searchController: UISearchController) {
        // if didn't typed anything in the search input field then don't filter results
        if searchController.searchBar.text! == "" {
            filteredCandies = productData
        } else {
        // Filter the results
            filteredCandies = productData.filter { $0.productname!.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
   
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

