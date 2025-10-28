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
