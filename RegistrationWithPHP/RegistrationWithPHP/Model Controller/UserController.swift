//
//  UserController.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/22/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

class UserController {
    var user: [User] = []
    init() {
        loadFromPersistenStore()
    }
    
    func saveToPersistentStore() {
        guard let url = persistentFileURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(user)
            try data.write(to: url)
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistenStore() {
        let fm = FileManager.default
        guard let url = persistentFileURL, fm.fileExists(atPath: url.path) else { return }

        print(url)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            user = try decoder.decode([User].self, from: data)
            
            
        } catch {
            print("Error loading books data: \(error.localizedDescription)")
        }
    }


    private var persistentFileURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

        return dir.appendingPathComponent("user.plist")
    }
    
    
    
    func registerUserWith(email: String, firstName: String, lastName: String, password: String, birthday: Date, gender: Int, completion: @escaping (User?, Error?) -> Void) {
        //Declaring url of the request: delcaring the body to the url: Declaring request with the safest method = POST, that no one can grab our info.
             let url = URL(string: "http://www.ultimate-teenchat.com/fb/register.php")!
             let body = "email=\(email.lowercased())&firstName=\(firstName.lowercased())&lastName=\(lastName.lowercased())&password=\(password)&birthday=\(birthday)&gender=\(gender)"
             
             var request = URLRequest(url: url)
             request.httpBody = body.data(using: .utf8)
        
             request.httpMethod = "POST"
             
             //Execute request from above
             URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                 //If there is an error
                 if let error = error {
                    print(error)
                     completion(nil, error)
                     return
                 }
                 
                guard let data = data else {
                    print(error!)
                    completion(nil, error)
                    return
                }
                 //Fetch JSON from server
                 
                 do {
                    
                    
                    let jsonDecoder = JSONDecoder()
                   // jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let user = try jsonDecoder.decode(User.self, from: data)
                    
                    self.user.append(user)
                    
                    print(user)
                    
                    completion(user, nil)
                    
                    self.saveToPersistentStore()

                 } catch {
                    print(error)
                    completion(nil, error)
                    return
                 }
                 
             }.resume()
    }
    
    func logUserIn(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        
        let url = URL(string: "http://www.ultimate-teenchat.com/fb/login.php")!
        let body = "email=\(email)&password=\(password)"
        
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        //Execute request from above
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                
                //If there is an error
                if let error = error {
                    print(error)
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    print(error!)
                    completion(nil, error)
                    return
                }
                //Fetch JSON from server
                
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let user = try jsonDecoder.decode(User.self, from: data)
                    
                    self.user.append(user)
                    
                    print(user)
                    
                    completion(user, nil)
                    
                    self.saveToPersistentStore()
                    
                } catch {
                    print(error)
                    completion(nil, error)
                    return
                }
            }
            
        }.resume()
    }
    
    func logout() {
        self.user.removeAll()
        saveToPersistentStore()
    }
}
