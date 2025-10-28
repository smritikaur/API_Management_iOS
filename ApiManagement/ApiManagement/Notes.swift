//
//  Notes.swift
//  ApiManagement
//
//  Created by singsys on 22/10/25.
//

//URLSession
/****
 URLSession is Apple's in build networking API that allows sending and retrieving data over the internet.
 It helps you perform HTTP request like GET, POST, PUT and DELETE while handling tasks such as downloading, uploading and caching.
 =============================================================================================
 Step 1: Make a API URL endpoint from where you need to access data
 -----
 let url = URL(string: "https://example.com/posts)
 
 Step 2: Create URLSessionTask
 -----
 Use URLSession to send request and retrieve the response
 
 let task = URLSession.shared.dataTask (with url: url ) {data, response, error in
 if let error = error {
    print("Error: \(error.localizedDescription)")
    return
 }
 guard let data = data else {
  print("No data received")
  return
 }
 
 if let jsonString = String(data: data, encoding: .utf8) {
   print("Response data: \(jsonString)")
  }
 }
 task.resume()
 
 ---- URLSession.shared.dataTask: Creates the network request
 ---- Closure ({ data, response, error in ... }): Handles the response and error
 ---- task.resume(): Starts the request
 
 
 Step 3: Decoding JSON Response
 -----
 Instead of parsing JSON response we can decode it into Swift struct.
 Define a Codable Model:
  struct Post: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String
 }
 
 Step 4: DECODE the json
 -----
 Modify the API call to decode the response into our Post struct.
 
 Modify the below code:
 if let jsonString = String(data: data, encoding: .utf8) {
   print("Response data: \(jsonString)")
  }
 
 To below:
 do {
     let post = JSONDecoder().decode(Post.self, from: data){
     print("Post Title: \(post.title)")
 } catch {
     print("Decoding error: \(error.localizedDescription)")
  }
 }
 =============================================================================================
 //MAKE A POST REQUEST
 A post request sends data to teh server such as creating a Post
 Step 1: Define Data to Send
 -----
 let newPost = Post(userId: 1, id: 101, title: "Hello, Swift!", body: "Learning networking in Swift is fun!")
 
 Step 2: Convert to JSON
 -----
 let jsonData = try? JSONEncoder().encode(newPost)
 
 Step 3: Create a URL Request
 -----
 var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.httpBody = jsonData
 
 Step 4: Send the Request
 -----
 let task = URLSession.shared.dataTask(with: request) { data, response, error in
     if let error = error {
         print("Error: \(error.localizedDescription)")
         return
     }
     
     if let httpResponse = response as? HTTPURLResponse {
         print("Response Status Code: \(httpResponse.statusCode)")
     }
     
     guard let data = data else {
         print("No data received")
         return
     }
 if let jsonString = String(data: data, encoding: .utf8) {
         print("Response Data: \(jsonString)")
     }
 }
 task.resume()
 =============================================================================================
 
 HANDLING ERRORS AND STATUS CODES
 -----------------------------------
 if let httpResponse = response as? HTTPURLResponse {
     if httpResponse.statusCode == 200 {
           print("Success!")
 } else {
         print("Failed with status code: \(httpResponse.statusCode)")
 }
}
 =============================================================================================
 */

/***
 ______________________
 SOLID PRINCIPLE
 ______________________
 Principle                          Focus                                               Benefit
 S                               Do one thing                               Simplicity, easier testing
 O                              Extend, don’t modify                   Flexible, future-proof
 L                               Substitutable subclasses            Reliable inheritance
 I                               Small interfaces                           Clean, focused design
 D                             Depend on abstractions               Loosely coupled, testable
 =============================================================================================
 Let’s explain each briefly:
 S — Single Responsibility Principle

 A class should do only one thing.

Keeps code simple, modular, and easy to maintain.
 Example:
 
Without SRP (Bad Example)
 class ReportManager {
     func generateReport() {
         print("Generating report...")
     }
     
     func saveToFile() {
         print("Saving report to file...")
     }
 }


 Problem:

 This class has two responsibilities:

 Generating the report

 Saving the report to a file

 If saving logic changes (e.g., now you need to save to a database or upload to cloud), you’d have to modify this same class — violating SRP.

With SRP (Good Example)
 class ReportGenerator {
     func generateReport() {
         print("Generating report...")
     }
 }

 class ReportSaver {
     func saveToFile() {
         print("Saving report to file...")
     }
 }


 Now:

 ReportGenerator only handles report creation.

 ReportSaver only handles file saving.

 Each has one reason to change — that’s the Single Responsibility Principle in action
 =============================================================================================
 O — Open/Closed Principle

 Classes should be open for extension, but closed for modification.

You should be able to add new features without changing existing code.

 Example:

 protocol Payment {
     func pay(amount: Double)
 }

 class CreditCardPayment: Payment {
     func pay(amount: Double) { print("Paid with credit card") }
 }

 class UPIPayment: Payment {
     func pay(amount: Double) { print("Paid with UPI") }
 }

 // Instead of editing old classes, just add new ones:
 class CryptoPayment: Payment {
     func pay(amount: Double) { print("Paid with crypto") }
 }


 No existing class changes — just extend via protocol (OCP ).
 =============================================================================================
 L — Liskov Substitution Principle

 Subtypes must be replaceable for their base types without altering correctness.

A subclass should behave like its parent class expects.

 Example (bad):

 class Bird {
     func fly() {}
 }

 class Penguin: Bird {
     override func fly() {
         fatalError("Penguins can’t fly!")
     }
 }


Violates LSP — Penguin can’t substitute Bird.

Fix: Separate interfaces:

 protocol FlyingBird { func fly() }
 protocol SwimmingBird { func swim() }
 =============================================================================================
 I — Interface Segregation Principle

 Don’t force classes to implement unneeded methods.

Prefer many small interfaces over one big “fat” one.

 Bad:

 protocol Worker {
     func work()
     func eat()
 }

 class Robot: Worker {
     func work() {}
     func eat() {} //  Robots don't eat
 }


 Good:

 protocol Workable { func work() }
 protocol Eatable { func eat() }

 class Human: Workable, Eatable { ... }
 class Robot: Workable { ... }
 =============================================================================================
 D — Dependency Inversion Principle

 High-level modules should depend on abstractions, not concrete implementations.

 Promotes loose coupling.

 Bad:

 class FileLogger {
     func log(_ message: String) { print("File log:", message) }
 }

 class UserService {
     let logger = FileLogger()
     func createUser() { logger.log("User created") }
 }


 Good:

 protocol Logger {
     func log(_ message: String)
 }

 class FileLogger: Logger {
     func log(_ message: String) { print("File log:", message) }
 }

 class UserService {
     let logger: Logger
     init(logger: Logger) {
         self.logger = logger
     }
     func createUser() { logger.log("User created") }
 }


 Now you can swap FileLogger with ConsoleLogger, DatabaseLogger, etc.
 DIP  — only depends on Logger protocol, not concrete classes.
 =============================================================================================
 */
