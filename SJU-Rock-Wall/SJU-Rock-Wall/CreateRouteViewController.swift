//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class CreateRouteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let ratings = ["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V10+"]
    let databaseRatings = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var pickerRow: Int = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        routeDifficulty.text = ratings[row]
        self.pickerRow = row
    }
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var routeName: UITextField!
    @IBOutlet weak var routeDifficulty: UITextField!
    @IBOutlet weak var routeDescription: UITextField!
    @IBOutlet weak var routeRating: UIPickerView!
    
    var serialScene: String!
    
    private var uid: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = UserDefaults.standard.string(forKey: "uid")
        
        if (uid != nil) {
            // something
        }
        
        let routeRating = UIPickerView()
        routeRating.delegate = self
        routeDifficulty.inputView = routeRating
    }
    
    @IBAction func submitButtonPress(_ sender: Any) {
        let name = routeName.text
        let difficulty = pickerRow
        let description = routeDescription.text
        
        serialScene = ""

        let json: [String: Any] = ["uid": uid!, "name": name!, "difficulty" : difficulty, "description": description!, "wallState" : serialScene!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/createRoute.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(serialScene)
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                print("made it here")
                
                let error = responseJSON["error"] as! Int
                if (error == 0) {
                    DispatchQueue.main.async {
                        let createRouteAlert = UIAlertController(title: "Success", message: "Route created successfully.", preferredStyle: UIAlertController.Style.alert)
                    
                        createRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                    
                        self.present(createRouteAlert, animated: true, completion: nil)
                    }
                }
                else if (error == 3) {
                    DispatchQueue.main.async {
                        let createRouteAlert = UIAlertController(title: "Error", message: "Route not created. Please try again.", preferredStyle: UIAlertController.Style.alert)
                    
                        createRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                        self.present(createRouteAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        task.resume()
    }
    
}
