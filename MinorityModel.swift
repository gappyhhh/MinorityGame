//
//  MinorityModel.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/08/24.
//

import Foundation
import Firebase

class ViewModel: ObservableObject{
    
    @Published var list = [MinorityTheme]()
    @Published var Internet = true
    
    
    func addData(Theme:String,question:String, name: String, notes:String){
        
        let db = Firestore.firestore()
        
        db.collection(Theme).addDocument(data:["Question":question,"Theme1":name,"Theme2":notes]){ error in
            //Check for errors
            if error == nil{
                //No errors
                //Call get data to retrieve latest data
                self.getData(Theme:Theme,completion: {},access: {})
            }
        }
    }
    
    
    func addReportData(question:String, name: String, notes:String){
        
        let db = Firestore.firestore()
        
        db.collection("通報内容").addDocument(data:["Type":question,"Genre":name,"Number":notes]){ error in
            //Check for errors
            if error == nil{
                //No errors
                //Call get data to retrieve latest data
                self.getReportData(completion: {})
            }
        }
    }
    
    func getData(Theme:String,completion: @escaping ()->(),access:@escaping ()->()) {
        let timer = Timer.scheduledTimer(withTimeInterval:5,repeats: false){_ in self.Internet = false
            access()
        }
        let db = Firestore.firestore()
        db.collection(Theme).getDocuments { snapshot, error in
            // Check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    DispatchQueue.main.async{
                        //Update the list property in the main thread
                    }
                    // Get all the documents and create MinorityTheme
                    self.list = snapshot.documents.map {d in
                        // Create a Minority item for each document returned
                        return MinorityTheme(id: d.documentID,
                                             question:d["Question"] as? String ?? "",
                                             name:d["Theme2"] as? String ?? "",
                                             notes:d["Theme1"] as? String ?? "")
                    }
                    if self.Internet == true{
                        timer.invalidate()
                        completion()
                    }
                }
            }
        }
    }
    
    
    func getReportData(completion: @escaping ()->()) {
        
        let db = Firestore.firestore()
        db.collection("通報内容").getDocuments { snapshot, error in
            // Check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    DispatchQueue.main.async{
                        //Update the list property in the main thread
                    }
                    // Get all the documents and create MinorityTheme
                    self.list = snapshot.documents.map {d in
                        // Create a Minority item for each document returned
                        return MinorityTheme(id: d.documentID,
                                             question:d["Question"] as? String ?? "",
                                             name:d["Theme2"] as? String ?? "",
                                             notes:d["Theme1"] as? String ?? "")
                    }
                    completion()
                }
            }
        }
    }
}
