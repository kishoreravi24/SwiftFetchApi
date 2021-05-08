//
//  ContentView.swift
//  FetchApi
//
//  Created by Kishore Jr on 08/05/21.
//

import SwiftUI

extension String {
    func load() -> UIImage {
        
        do {
            //convert string to URL
            guard let url = URL(string: self) else {
                return UIImage()
            }
            
            //convert url to data
            let data: Data = try Data(contentsOf: url)
            
            
            //create UIImage object from Data
            return UIImage(data: data) ?? UIImage()
        } catch {
            
        }
        
        return UIImage()
    }
}



struct ContentView: View {
    @State var models: [ResponseModel] = []

    var body: some View {
        VStack {
            //list
            List(self.models) {(model) in
                VStack{
                    Text(model.Title)
                    Image(uiImage: model.Poster.load())
                        .resizable()
                }
            }
        }.onAppear(perform: {
            guard let url = URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=111fe04a") else {
                print("Error in url")
                return
            }
            
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: urlRequest) {(data,response,error) in
                if let data = data {
                    do {
                        let response_data = try JSONDecoder().decode(ResponseModel.self, from: data)
                        DispatchQueue.main.async {
                            self.models = [response_data]
                        }
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                } else {
                    print("error in data")
                }
            }.resume()
        })
    }
    
}

//create Type
class ResponseModel: Codable, Identifiable {
    var Title: String
    var Poster: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
