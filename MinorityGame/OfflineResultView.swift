//
//  OfflineResultView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/06.
//

import SwiftUI
import Firebase

struct OfflineResultView: View {
    @Binding var Question:String
    @Binding var memberAll:[String]
    @Binding var memberArray:[String]
    @Binding var memberArray2:[String]
    @Binding var Theme1:String
    @Binding var Theme2:String
    @Binding var selection: Int
    @Binding var CategoryArray: [String]
    @Binding var ResultCount1: Int
    @Binding var ResultCount2: Int
    @Binding var OfflineResultShow_red :Bool
    @Binding var OfflineResultShow_white :Bool
    @Binding var anonymous:Bool
    @Binding var ResultMemberArray1:[String]
    @Binding var ResultMemberArray2:[String]
    @Binding var path:NavigationPath
   
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        ZStack {
            // 背景指定
            if height/width < 2{
                Image("Background9_16")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            if height/width >= 2{
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .center,spacing:10) {
                Image("Result")
                    .resizable(capInsets: EdgeInsets())
                    .scaledToFit()
                    .frame(width:CGFloat(width)/1.5)
                    
                HStack{
                    Text("Q.")
                        .font(.system(size:CGFloat(width)/15))
                    Text(Question)
                        .font(.system(size:CGFloat(width)/18))
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }

                Spacer()
                
                HStack(alignment: .bottom,spacing:20){
                    VStack(spacing:0){
                        
                        Text(Theme1)
                            .fontWeight(.semibold)
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(Color.gray.cornerRadius(20).opacity(0.2))
                            .font(.system(size:CGFloat(height)/45))
                            .compositingGroup()
                            .shadow(color:.primary.opacity(0.4),radius: 3,x:4,y:4)
                        
                        Spacer()
                        
                        Text("\(ResultMemberArray1.count)")
                            .padding(5)
                            .font(.system(size:CGFloat(height)/35))
                        
                        if anonymous == true {
                            ForEach(0..<ResultMemberArray1.count, id:\.self ) {
                                index in Text(ResultMemberArray1[index])
                                    .padding(4)
                                    .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/21)
                                    .font(.system(size:CGFloat(height)/35))
                                    .foregroundColor(Color.black)
                                    .background(OfflineResultShow_red ? .white:.red)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        } else {
                            Text(" ")
                                .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(ResultMemberArray1.count)/21)
                                .foregroundColor(Color.black)
                                .background(OfflineResultShow_red ? .white:.red)
                                .font(.system(size:CGFloat(height)/45))
                        }
                    }

                    VStack(spacing:0){
                        
                        Text(Theme2)
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(Color.gray.cornerRadius(20).opacity(0.2))
                            .font(.system(size:CGFloat(height)/45))
                            .compositingGroup()
                            .shadow(color:.primary.opacity(0.4),radius: 3,x:4,y:4)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(ResultMemberArray2.count)")
                            .padding(5)
                            .font(.system(size:CGFloat(height)/35))
                        
                        if anonymous == true {
                            ForEach(0..<ResultMemberArray2.count, id:\.self ) {
                                index in Text(ResultMemberArray2[index])
                                    .padding(4)
                                    .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/21)
                                    .font(.system(size:CGFloat(height)/35))
                                    .foregroundColor(Color.black)
                                    .background(OfflineResultShow_white ? .white:.red)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        } else {
                            Text(" ")
                                .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(ResultMemberArray2.count)/21)
                                .foregroundColor(Color.black)
                                .background(OfflineResultShow_white ? .white:.red)
                                .font(.system(size:CGFloat(height)/45))
                        }
                    }
                }.padding(.bottom)
                
                HStack(alignment: .bottom,spacing:20){
                    Text("名前を表示する：")
                        .padding(.bottom,CGFloat(height)/200)
                    Toggle("",isOn:$anonymous).labelsHidden()
                        .onAppear {
                            //初期値を代入
                            anonymous = false
                        }
                }

                // 次の問題へボタンの定義
                Button(action:{
                    ResultMemberArray1.removeAll()
                    ResultMemberArray2.removeAll()
                    Theme1=""
                    Theme2=""
                    Question=""
                    path.append("ChooseTopicView")}) {
                    Image("NextTheme")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:CGFloat(width)/2)
                }.padding(.bottom, CGFloat(width)/20)
                }
                }.navigationBarBackButtonHidden(true)
        
            }
        }


struct OfflineResultView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineResultView(Question: .constant("質問"),
                          memberAll: .constant(["回答者の名前"]),
                          memberArray: .constant(["回答者の名前1"]),
                          memberArray2: .constant(["回答者の名前2"]),
                          Theme1: .constant("お題1"),
                          Theme2: .constant("お題2"),
                          selection:.constant(0),
           CategoryArray:.constant(["恋愛"]),
                          ResultCount1: .constant(8),
                          ResultCount2: .constant(2),
                          OfflineResultShow_red: .constant(true),
                          OfflineResultShow_white: .constant(false),
                          anonymous: .constant(true),
                          ResultMemberArray1: .constant(["回答者結果1"]),
                          ResultMemberArray2: .constant(["回答者結果1"]),
                          path:.constant(NavigationPath("パス")))
               
    }
}
