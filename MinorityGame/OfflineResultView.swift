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
                //                .aspectRatio(contentMode: .fill)
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
                    VStack{
//                        Text(String(ResultCount1))
//                            .font(.system(size:CGFloat(width)/12))
                        Text(Theme1)
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(OfflineResultShow_red ? .white:.red)
                            .font(.system(size:CGFloat(height)/45))
//                        if anonymous == false{
                            ForEach(0..<ResultMemberArray1.count, id:\.self ){index in Text(ResultMemberArray1[index])
                                    .padding(4)
                                    .frame(width:CGFloat(width)/2.4).font(.system(size:CGFloat(height)/42))
                                    .background(Color.gray)
                                    .foregroundColor(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
//                        }
                            
                    }
                    VStack{
//                        Text(String(ResultCount2))
//                            .font(.system(size:CGFloat(width)/12))
                        Text(Theme2)
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(OfflineResultShow_white ? .white:.red)
                            .font(.system(size:CGFloat(height)/45))
//                        if anonymous == false{
                            ForEach(0..<ResultMemberArray2.count, id:\.self ){index in Text(ResultMemberArray2[index])
                                    .padding(4)
                                    .frame(width:CGFloat(width)/2.4).font(.system(size:CGFloat(height)/42))
                                    .background(Color.gray)
                                    .foregroundColor(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
//                        }
                    }
                    
                        
                }.padding(.bottom)
                Text("選んだ理由について話し合ってみよう！")
                    .font(.system(size:CGFloat(width)/22))
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
                        .frame(width:CGFloat(width)/1.4)
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
