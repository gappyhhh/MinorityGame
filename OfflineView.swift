//
//  OfflineView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/05.
//

import SwiftUI

struct OfflineView: View {
    @State var ResultArray:[String] = []
    @State var membernumber = 0
    @State var LeftTheme : Bool = false
    @State var RightTheme : Bool = false
    @Binding var OfflineResultShow_red : Bool
    @Binding var OfflineResultShow_white : Bool
    @Binding var ResultMemberArray1:[String]
    @Binding var ResultMemberArray2:[String]
    @Binding var memberAll:[String]
    @Binding var memberArray:[String]
    @Binding var memberArray2:[String]
    @Binding var Question : String
    @Binding var Theme1 : String
    @Binding var Theme2 : String
    @Binding var selection: Int
    @Binding var CategoryArray: [String]
    @Binding var anonymous:Bool
    @Binding var path:NavigationPath
    @Binding var ResultCount1:Int
    @Binding var ResultCount2:Int
    
    
    
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
            
            VStack {
                // 説明欄
                if selection == 1{
                    Image("LoveTheme")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(width:CGFloat(width)/1.4)
                }
                
                if selection == 2{
                    Image("SportTheme")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(width:CGFloat(width)/1.4)
                }
                
                if selection == 3{
                    Image("WorkTheme")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(width:CGFloat(width)/1.4)
                }
                
                    Text(memberAll[membernumber])
                        .font(.system(size:CGFloat(width)/15))
                        .frame(width:CGFloat(width)/2)
                        .padding(3)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                HStack{
                    Text("Q.")
                        .font(.system(size:CGFloat(width)/15))
                        
                    Text(Question)
                        .font(.system(size:CGFloat(width)/15))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    //                        .background(Color.white)
                }.padding()
                
                
                HStack(alignment: .top,spacing:25){
                    Button(action:{LeftTheme = true
                        RightTheme = false
                    },label:{
                        Rectangle()
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/2.3)
                            .foregroundColor(LeftTheme ? Color(red:117/255,green:175/255,blue:165/255):.white)
                            .overlay(
                                Text(Theme1)
                                    .foregroundColor(.black)
                                    .font(.system(size:20))
                            )
                    }).shadow(color:.primary.opacity(0.2),radius: 3,x:4,y:4)
                    Button(action:{RightTheme = true
                        LeftTheme = false
                    },label:{
                        Rectangle()
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/2.3)
                            .foregroundColor(RightTheme ? Color(red:117/255,green:175/255,blue:165/255):.white)
                            .overlay(
                                Text(Theme2)
                                    .foregroundColor(.black)
                                    .font(.system(size:20))
                            )
                    }).shadow(color:.primary.opacity(0.2),radius: 3,x:4,y:4)
                }
                Spacer()

                // 「OK」ボタンの定義
                Button(action:{
                    
                    
                    if LeftTheme == true{
                        ResultArray.append(Theme1)
                        ResultMemberArray1.append(memberAll[membernumber])
                    }
                    if RightTheme == true{
                        ResultArray.append(Theme2)
                        ResultMemberArray2.append(memberAll[membernumber])
                    }
                    if ResultArray.count < memberAll.count{
                        membernumber = membernumber+1
                    }
                    LeftTheme = false
                    RightTheme = false
                    print(ResultArray)
                    if ResultArray.count >= memberAll.count{
                        ResultCount1 = ResultArray.filter {$0.contains(Theme1)}.count
                        ResultCount2 = ResultArray.filter {$0.contains(Theme2)}.count
                        print(ResultCount1,ResultCount2)
                        path.append("OfflineResultView")
                        if ResultCount1 > ResultCount2{
                            OfflineResultShow_red = true
                            OfflineResultShow_white = false
                        }
                        if ResultCount1 < ResultCount2{
                            OfflineResultShow_red = false
                            OfflineResultShow_white = true
                            
                        }
                        if ResultCount1 == ResultCount2{
                            OfflineResultShow_red = true
                            OfflineResultShow_white = true
                            
                        }
                    }
                    
                    
                    
                }) {
                    if LeftTheme == false && RightTheme == false {
                        Image("OKButtonGrey")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.5)
                    }
                    if LeftTheme || RightTheme == true{
                        Image("OKButton")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.5)
                    }
                }.disabled(LeftTheme == false && RightTheme == false )
                Spacer()
            }
            
        }.navigationBarBackButtonHidden(true)
        
    }
}


struct OfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineView(
                    OfflineResultShow_red: .constant(true),
                    OfflineResultShow_white:.constant(true),
                    ResultMemberArray1: .constant(["回答者結果1"]),
                    ResultMemberArray2: .constant(["回答者結果2"]),
                    memberAll: .constant(["回答者の名前"]),
                    memberArray: .constant(["回答者の名前1"]),
                    memberArray2: .constant(["回答者の名前2"]),
                    Question: .constant("質問"),
                    Theme1:.constant("テーマ1"),
                    Theme2:.constant("テーマ2"),
                    selection: .constant(1),
                    CategoryArray: .constant(["恋愛"]),
                    anonymous: .constant(true),
                    path:.constant(NavigationPath("パス")),
                    ResultCount1: .constant(0),
                    ResultCount2: .constant(0)
                    
                    )
    }
}
