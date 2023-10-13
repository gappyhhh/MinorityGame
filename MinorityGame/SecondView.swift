//
//  SecondView.swift
//  Helloworld
//
//  Created by kazuhiro hirata on 2023/08/19.
//
//

import SwiftUI
import Firebase
import UIKit

//ContentViewで受け渡された変数はBindingで受け取る
struct SecondView: View {
    @Binding var memberArray:[String]
    @Binding var memberArray2:[String]
    @Binding var memberAll:[String]
    @Binding var ButtonCount:Int
    @Binding var anonymous:Bool
    @Binding var path: NavigationPath
    @Binding var ThemeArray1:[String]
    @Binding var ThemeArray2:[String]
    @Binding var CategoryArray:[String]
    @Binding var selection:Int
    @Binding var QuestionArray:[String]
    @Binding var Themenumber:Int
    @Binding var ONlineResultShow_red : Bool
    @Binding var ONlineResultShow_white : Bool
    @Binding var ResultMemberArray1:[String]
    @Binding var ResultMemberArray2:[String]
    @Binding var ResultCount1:Int
    @Binding var ResultCount2:Int
    
    

    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        
        //本文
        ZStack {
            //背景指定
            if height/width < 2{
                Image("Background9_16")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            if height/width >= 2{
                Image("Background")
                    .resizable()
                //                .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

            }
           
            VStack(alignment: .center,spacing:20) {
                
                Spacer()
                // プレイ人数画像配置
                Image("entry")
                    .resizable(capInsets: EdgeInsets())
                    .scaledToFit()
                    .frame(width:CGFloat(width)/1.3)
                
                // 人数設定のボタンを横に並べる
                HStack(alignment: .center,spacing:50) {
                    // マイナスボタン配置
                    Button(action:{ButtonCount = ButtonCount - 1
                        if (ButtonCount < 4) {
                            memberArray.removeLast()
                        } else {memberArray2.removeLast()}}) {
                            Image("minus")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width:CGFloat(width)/7)
                        }.foregroundColor(memberArray.count == 1 ?.gray : .red).disabled(memberArray.count==1)
                    
                    // 人数表示
                    Text("\(ButtonCount)").font(.system(size:50))
                    
                    // プラスボタン配置
                    Button(action:{ButtonCount = ButtonCount + 1
                        print(ButtonCount)
                        print(memberArray)
                        if (ButtonCount < 5) {
                            memberArray.append("")
                        } else {memberArray2.append("")}}) {
                            Image("plus")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width:CGFloat(width)/7)
                        }.foregroundColor(.blue).disabled(ButtonCount==8).padding(5)
                }
                
                // メンバー記入欄定義
                ScrollView {
                    HStack {
                        VStack {
                            ForEach(memberArray.indices, id:\.self) {i in
                                TextField("プレイヤー\(i+1)",text:$memberArray[i])
                                    .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width:CGFloat(width)/2.2).font(.system(size:CGFloat(width)/18))
                                
                            }.frame(maxWidth: .infinity)
                            Spacer()
                        }
                        // メンバーが6人以上の場合は2列表示
                        if (memberArray2.count >= 1) {
                            VStack {
                                ForEach(memberArray2.indices, id:\.self) {i in
                                    TextField("メンバー\(i+5)",text:$memberArray2[i])
                                        .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width:CGFloat(width)/2.2).font(.system(size:CGFloat(width)/18))
                                    
                                }.frame(maxWidth: .infinity)
                                Spacer()
                            }
                        }
                    }
                }
                
//                HStack{
//                    Spacer().frame(width: 30)
//                    Text("結果を匿名表示にする")
//                        // .font(.system(size: 18))
//                    Toggle(isOn: $anonymous){}
//                        .padding()
//                }
                
                // 「お題設定へ」ボタンの定義
                Button(action:{memberAll.removeAll()
                    //一列目と二列目のメンバー名を足してmemberAllにメンバー名を格納
                    memberAll.append(contentsOf: memberArray + memberArray2)
                    //ContentViewで定義したcase "ビュー名"に遷移
                    path.append("ChooseTopicView")
                }) {
                    //メンバー欄に空欄がある場合は、グレーのボタンを表示
                    if (memberArray.filter({$0.isEmpty}).count>0 || memberArray2.filter({$0.isEmpty}).count>0) {
                        Image("Decide_grey")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.2)
                            .padding()
                    }
                    else {
                        Image("ThemeSwitch")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.2)
                            .padding()
                        
                    }
                    
                    
                }
                //メンバー欄に空欄がある場合は、ボタンを押せなくする
                .disabled(memberArray.filter({$0.isEmpty}).count>0 || memberArray2.filter({$0.isEmpty}).count>0)
//                .navigationDestination(isPresented: $isPresented2) {
//                ChooseTopicPage(memberAll:$memberAll,
//                                anonymous:$anonymous,
//                                memberArray:$memberArray,
//                                memberArray2:$memberArray2,
//                                path:$path)
             
//                .alert("投票結果に名前を表示する",isPresented: $anonymousWhich){
//                    Button("はい"){
//                        anonymous = false
//                        path.append("ChooseTopicPage")
//                    }
//                    Button("いいえ"){
//                        anonymous = true
//                        path.append("ChooseTopicPage")
//                    }
//                }
                    
                
              
//                Toggle("",isOn:$anonymous).labelsHidden()
            }
        }.ignoresSafeArea(.keyboard,edges: .bottom)
            
    }
}
    
//以下はプレビュー表示で使用する。冒頭のBindingで定義した変数に初期値がいるため、.constantで定義。
//.constant内の内容は、型さえ変数と合致していればなんでもいい。
struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(memberArray: .constant(["回答者の名前1"]),
                   memberArray2: .constant(["回答者の名前2"]),
                   memberAll: .constant(["回答者の名前全員"]),
                   ButtonCount: .constant(0),
                   anonymous: .constant(true),
                   path: .constant(NavigationPath("パス")),
                   ThemeArray1:.constant(["お題1"]),
                   ThemeArray2:.constant(["お題2"]),
                   CategoryArray: .constant(["ジャンル"]),
                   selection: .constant(0),
                   QuestionArray: .constant(["質問"]),
                   Themenumber: .constant(0),
                   ONlineResultShow_red: .constant(true),
                   ONlineResultShow_white: .constant(false),
                   ResultMemberArray1: .constant(["回答者結果1"]),
                   ResultMemberArray2:.constant(["回答者結果1"]),
                   ResultCount1: .constant(1),
                   ResultCount2: .constant(1)
        )
    }
}
