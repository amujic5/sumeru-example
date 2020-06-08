//
//  ViewController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 20/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

struct Section {
    let title: String
    let items: [String]
}

class ViewController: UITableViewController {

    var sections: [Section] = [
        Section(title: "Home rentals", items: [
            "https://www.pepperfry.com/",
            "https://www.flipkart.com/",
            "https://www.commonfloor.com/",
            "https://www.nestaway.com/",
            "https://www.practo.com/"
        ]),
        Section(title: "Health care ", items: [
            "https://pharmeasy.in/",
            "https://www.srisritattva.com/",
            "https://mitraz.financial/"
        ]),
        Section(title: "Financial service", items: [
            "https://www.tatacapital.com/",
            "https://www.creditmantri.com/",
            "https://www.godigit.com/",
            "https://dsp.com",
            "https://Zopnow.com",
            "https://Dailyninja.com",
            "https://Grofers.com",
            "https://Bigbasket.com"
        ]),
        Section(title: "Online grocery", items: [
            "https://Dlhivery.com",
            "https://Dunzo.com",
            "https://Bluetokai.com",
            "https://Corridor7coffee.com",
            "https://Wefast.com"
        ]),
        Section(title: "Courier pick up and delivery services", items: [
            "https://Freshmenu.com",
            "https://Box8.com",
            "https://Wefast.com",
            "https://Delhivery.com",
            "https://Dunzo.com"
        ]),
        Section(title: "Rent", items: [
            "https://mojo.com"
        ]),
        Section(title: "Home appliances", items: [
            "https://Pepperfry.com",
            "https://Renttickle.com",
            "https://Croma.com",
            "https://Cityfurnish.com",
            "https://Furlenco.com"
        ]),
        Section(title: "Furniture rentals", items: [
            "https://Furlenco.com",
            "https://Cityfurnish.com",
            "https://Rentmojo.com",
            "https://Renttickle.com",
            "https://Pepperfry.com"
        ]),
        Section(title: "Home appliances", items: [
            "https://Croma.com",
            "https://Shopclues.com"
        ]),
        Section(title: "Online Food Ordering", items: [
            "https://Box8.com",
            "https://Freshmenu.com",
            "https://Bluetokai.com",
            "https://Corridor7coffee.com",
            "https://clues.com "
        ])
    ]
    
    lazy var historyBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(didTap(barButtonItem:)))
    }()

    
    @objc func didTap(barButtonItem: UIBarButtonItem) {
        navigationController?.pushViewController(MallViewController(), animated: true)
        //navigationController?.pushViewController(PaymentsViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        tableView.backgroundColor = .white
            
        navigationController?.view.backgroundColor = .white
        navigationItem.title = "List"
        
        navigationItem.rightBarButtonItem = historyBarButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = sections[indexPath.section].items[indexPath.row]
        self.navigationController?.pushViewController(WebViewController(urlString: item), animated: true)
        
    }
    

}

