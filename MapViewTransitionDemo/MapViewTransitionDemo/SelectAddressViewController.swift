//
//  SelectAddressViewController.swift
//  MapViewTransitionDemo
//
//  Created by huangxh on 2020/4/1.
//  Copyright © 2020 Alan. All rights reserved.
//

import UIKit
import MapKit

enum AddressType {
    case start
    case end
}

typealias SelectAddressCallback = (Location,AddressType) -> Void

/// 选择地址,点击某个地址后会执行回调
class SelectAddressViewController: UIViewController {
    
    var addressType: AddressType? = nil
    var didSelectAddressCallback:SelectAddressCallback?
    var datasource:[Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }

}

extension SelectAddressViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //search textfield.text
        if let text = textField.text,!text.isEmpty {
            
            MapUtility.searchLocationsWith(keyword: text) {[weak self] locations in
                guard let self = self else { return }
                if locations == nil{
                    let alertController = UIAlertController(title: "Error", message: "No Result", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    self.datasource.removeAll()
                    self.datasource.append(contentsOf: locations!)
                    self.tableView.reloadData()
                    
                }
            }
        }
        return true
    }
}

extension SelectAddressViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.textLabel?.numberOfLines = 0
        let location = datasource[indexPath.row]
        cell?.textLabel?.text = location.name
        cell?.detailTextLabel?.text = location.address
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = datasource[indexPath.row]
        didSelectAddressCallback?(location,addressType!)
        dismiss(animated: true, completion: nil)
    }
}
