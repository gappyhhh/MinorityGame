//
//  MinorityModel.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/08/24.
//

import Foundation
import Firebase
import UIKit
import BackgroundTasks

class ViewModel: ObservableObject{
    
    @Published var list = [MinorityTheme]()
//    @Published var Ownlist = [OwnTheme]()
    @Published var Internet = true
    @Published var owntheme_theme1 : String = ""
    
    //name = Theme2
    //notes = Theme1
    
    func updateData(Theme:String,id:String,ResultCounter1:Int,ResultCounter2:Int){
        let db = Firestore.firestore()
        
        db.collection(Theme).document(id).setData(["Average1": ResultCounter1],merge: true)
        db.collection(Theme).document(id).setData(["Average2": ResultCounter2],merge: true)
        
    }
    
    func searchData(Theme:String,id:String)->String{
        let db = Firestore.firestore()
        db.collection(Theme).document(id).getDocument { (document,error) in
            guard error == nil else{
                print("error")
                return
            }
            if let document = document,document.exists{
                let data = document.data()
                if let data = data{
                    DispatchQueue.main.asyncAfter(deadline: .now()+3){
                        //Update the list property in the main thread
                        
                        self.owntheme_theme1 = data["Theme1"] as? String ?? ""
                        print(self.owntheme_theme1)
                    }
                }
            }
        }

        return owntheme_theme1
    }
    
//    func newsearchData(Theme:String,id:String,completion: @escaping ()->()){
//        let db = Firestore.firestore()
//        let docRef = db.collection(Theme).document(id)
//        docRef.getDocument {(document,error) in
//            if let document = document,document.exists{
//                DispatchQueue.main.async{
//                    //Update the list property in the main thread
//                }

//                //                   let question = docDict["Question"] as? String,
//                //                   let theme1 = docDict["Theme1"] as? String,
//                //                   let theme2 = docDict["Theme2"] as? String,
//                //                   let Count1 = docDict["Average1"] as? Int,
//                //                   let Count2 = docDict["Average2"] as? Int {
//                //                   let dataDescription = "Question->\(question),Theme1->\(theme1),Theme2->\(theme2),Average1->\(Count1),Average2->\(Count2)"
//                completion()
//            }
//            else{
//                print("cannot retrieve data")
//            }
//
//        }
//    }
    
    func addData(Theme:String,question:String, name: String, notes:String)->String{
        
        let db = Firestore.firestore()
        let useid = db.collection(Theme).document().documentID
        db.collection(Theme).document(useid).setData(["Question":question,"Theme1":name,"Theme2":notes]){ error in
//        db.collection(Theme).addDocument(data:["Question":question,"Theme1":name,"Theme2":notes]){ error in
            //Check for errors
            if error == nil{
                //No errors
                //Call get data to retrieve latest data
                self.getData(Theme:Theme,completion: {},access: {})
            }
        }
        return useid
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
                                             name:d["Theme1"] as? String ?? "",
                                             notes:d["Theme2"] as? String ?? "",
                                             Count1: d["Average1"] as? Int ?? Int(),
                                             Count2: d["Average2"] as? Int ?? Int())
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
                                             name:d["Theme1"] as? String ?? "",
                                             notes:d["Theme2"] as? String ?? "",
                                             Count1: d["Average1"] as? Int ?? Int(),
                                             Count2: d["Average2"] as? Int ?? Int())
                    }
                    completion()
                }
            }
        }
    }
}

//class User{
//    let question: String
//    let theme1:String
//    let theme2:String
//    let count1:Int
//    let count2:Int
//
//    init(dic:[String:Any])
//    {
//        self.question = dic["Question"] as? String ?? ""
//        self.theme1 = dic["Theme1"] as? String ?? ""
//        self.theme2 = dic["Theme2"] as? String ?? ""
//        self.count1 = dic["Average1"] as? Int ?? Int()
//        self.count2 = dic["Average2"] as? Int ?? Int()
//    }
//}
