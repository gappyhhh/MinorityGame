//
//  FourthView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/08/26.
//

import SwiftUI
import Firebase
import UIKit

struct FourthView: View {
    @ObservedObject var model = ViewModel()
    @State var Theme1 = ""
    @State var Theme2 = ""
    
    @FocusState private var isKeybordon : Bool
    @State var LeftTheme : Bool = false
    @State var RightTheme : Bool = false
    @State var OKButton : Bool = false
    @State var Themeresult1:[String]=[]
    @State var Themeresult2:[String]=[]
    @State var ResultArray:[String]=[]
    @State var membernumber = 0
    @State var Skipbutton = false
    @State var Firstanswer = true
    @State var showingDialog = false
    @State var showingModal = false
    @State private var report = ["不適切・不快な内容である","性的に不適切な内容を含んでいる","政治的問題に関連している","個人情報が記載されている","未完成のお題である"]
    @State private var selectedValue: String?
    @State private var presentationDetent = PresentationDetent.medium
    @State private var FinishReport = false
   
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
    @Binding var ThemeidArray:[String]
    @Binding var ReportidArray:[String]
    
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
                
                if selection == 8{
                    Image("Other")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(width:CGFloat(width)/1.4)
                }
                
                    Text(memberAll[membernumber])
                        .font(.system(size:CGFloat(width)/15))
                        .padding(3)
                        .frame(width:CGFloat(width)/2)
                        .foregroundColor(Color.white)
                        .background(Color.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                HStack{
                    Text("Q.")
                        .font(.system(size:CGFloat(width)/15))
                    Text(QuestionArray[Themenumber])
                        .font(.system(size:CGFloat(width)/15))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }.padding()
                HStack(alignment: .top,spacing:25){
                    Button(action:{LeftTheme = true
                        RightTheme = false
                    },label:{
                        Rectangle()
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/2.3)
                            .foregroundColor(LeftTheme ? Color(red:117/255,green:175/255,blue:165/255):.white)
                            .overlay(
                                Text(ThemeArray1[Themenumber])
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
                                Text(ThemeArray2[Themenumber])
                                    .foregroundColor(.black)
                                    .font(.system(size:20))
                            )
                    }).shadow(color:.primary.opacity(0.2),radius: 3,x:4,y:4)
                }

                
                if Firstanswer == true{
                    
                    Button(action:{
                        if Themenumber == QuestionArray.count-1{
                            Themenumber = -1
                        }
                            Themenumber = Themenumber + 1
                        LeftTheme = false
                        RightTheme = false
                    }) {
                        Image("SkipButton")
                            .renderingMode(.original)
                            .resizable()
                            
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.5)
                            .padding(.trailing)
                            .padding(.top)
                    }
                    
                    Button(action:{
                        showingDialog = true
                    }) {
                        Image("ReportButton")
                            .renderingMode(.original)
                            .resizable()
                            
                            .scaledToFit()
                            .frame(width:CGFloat(width)/2)
                            
                    }
                    .sheet(isPresented:$showingModal){
                        NavigationStack{
                            VStack{
                                List(selection:$selectedValue){
                                    ForEach(report,id: \.self){str in Text("\(str)")}
                                }.environment(\.editMode,.constant(.active))
                                Button("報告"){
                                    
                                    model.addReportData(question: selectedValue! ,name: CategoryArray[selection], notes: ThemeidArray[Themenumber])
                                    ReportidArray.append(ThemeidArray[Themenumber])
                                    print(ReportidArray)
                                    FinishReport = true
                                    
                                   
                                }.alert("報告が完了しました",isPresented: $FinishReport){
                                    Button("OK"){
                                        showingModal = false
                                        if Themenumber == QuestionArray.count-1{
                                            Themenumber = -1
                                        }
                                        Themenumber = Themenumber+1
                                        
                                    }
                                }
                                .font(.system(size:20))
                                .padding(1)
                                .foregroundColor(.red)
                                
                                    
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("報告理由を選択")
                            .toolbar{
                                Button("閉じる", role:.cancel){
                                    showingModal.toggle()
                                }
                            }
                        }.presentationDetents([.medium,.large],selection: $presentationDetent)
                        
                    }
                    
                    
                    .confirmationDialog("お題の内容が不適切な場合は報告してください。", isPresented: $showingDialog, titleVisibility:.visible){
                        Button("報告する",role:.destructive){
                            showingDialog = false
                            showingModal=true
                            selectedValue = nil
                        }
                        Button("キャンセル",role:.cancel){
                        }
                    }
                }
                Spacer()
                // 「OK」ボタンの定義
                Button(action:{
                   
                    print(membernumber,memberAll.count-1)
                    if LeftTheme == true{
                        ResultArray.append(ThemeArray1[Themenumber])
                        ResultMemberArray1.append(memberAll[membernumber])
                    }
                    if RightTheme == true{
                        ResultArray.append(ThemeArray2[Themenumber])
                        ResultMemberArray2.append(memberAll[membernumber])
                    }
                    if ResultArray.count < memberAll.count{
                        membernumber = membernumber+1
                    }
                    LeftTheme = false
                    RightTheme = false
                    Firstanswer = false
                    print(ResultArray)
                    if ResultArray.count >= memberAll.count{
                        ResultCount1 = ResultArray.filter {$0.contains(ThemeArray1[Themenumber])}.count
                        ResultCount2 = ResultArray.filter {$0.contains(ThemeArray2[Themenumber])}.count
                        print(ResultCount1,ResultCount2)
                        path.append("ResultView")
                        if ResultCount1 > ResultCount2{
                            ONlineResultShow_red = true
                            ONlineResultShow_white = false
                        }
                        if ResultCount1 < ResultCount2{
                            ONlineResultShow_red = false
                            ONlineResultShow_white = true
                            
                        }
                        if ResultCount1 == ResultCount2{
                            ONlineResultShow_red = true
                            ONlineResultShow_white = true
                            
                        }
                        
                        print(ONlineResultShow_red,ONlineResultShow_white)
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
                }.disabled(LeftTheme == false && RightTheme == false)
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}
    
struct FourthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView(memberArray: .constant(["回答者の名前1"]),
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
                   ResultCount2: .constant(1),
                   ThemeidArray: .constant(["id"]),
                   ReportidArray: .constant(["報告済のお題"])
        )
    }
}
