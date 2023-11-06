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
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ReportModel.reportid,ascending: true)],animation: .default)
    private var reportid: FetchedResults<ReportModel>
    
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
    @State var RemoveArray:[Int] = []
   
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
    @Binding var AllThemeArray1:[[String]]
    @Binding var AllThemeArray2:[[String]]
    @Binding var AllQuestionArray:[[String]]
    @Binding var AllThemeidArray:[[String]]
    @Binding var Theme1CounterArray:[Int]
    @Binding var Theme2CounterArray:[Int]
    @Binding var AllTheme1CounterArray:[[Int]]
    @Binding var AllTheme2CounterArray:[[Int]]
    @Binding var AlreadyThemeArray:[[String]]
    
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
//                if selection == 1{
//                    Image("LoveTheme")
//                        .resizable(capInsets: EdgeInsets())
//                        .scaledToFit()
//                        .frame(width:CGFloat(width)/1.4)
//            
//                }
//                
//                if selection == 2{
//                    Image("SportTheme")
//                        .resizable(capInsets: EdgeInsets())
//                        .scaledToFit()
//                        .frame(width:CGFloat(width)/1.4)
//                }
//                
//                if selection == 3{
//                    Image("WorkTheme")
//                        .resizable(capInsets: EdgeInsets())
//                        .scaledToFit()
//                        .frame(width:CGFloat(width)/1.4)
//                }
//                
//                if selection == 8{
//                    Image("Other")
//                        .resizable(capInsets: EdgeInsets())
//                        .scaledToFit()
//                        .frame(width:CGFloat(width)/1.4)
//                }
                
                
//                if Firstanswer == true{
                                        
                    HStack{
                        if Firstanswer == false{
                            Spacer().frame(height:CGFloat(width)/14.5)
                        }
                        if Firstanswer == true{
                            Spacer()
                        Button(action:{
                            showingDialog = true
                        }) {
                            Image("Bell")
                                .renderingMode(.original)
                                .resizable()
                            
                                .scaledToFit()
                                .frame(width:CGFloat(width)/15)
                                .padding(.trailing)
                            
                        }
                        .sheet(isPresented:$showingModal){
                            NavigationStack{
                                VStack{
                                    List(selection:$selectedValue){
                                        ForEach(report,id: \.self){str in Text("\(str)")}
                                    }.environment(\.editMode,.constant(.active))
                                    Button("報告"){
                                        
                                        model.addReportData(question: selectedValue! ,name: CategoryArray[selection], notes: ThemeidArray[Themenumber])
                                        let newThemeModel = ReportModel(context:context)
                                        newThemeModel.reportid = ThemeidArray[Themenumber]
                                        try? context.save()
                                        ReportidArray.append(ThemeidArray[Themenumber])
                                        print(ReportidArray)
                                        FinishReport = true
                                        
                                        
                                    }.alert("報告が完了しました",isPresented: $FinishReport){
                                        Button("OK"){
                                            showingModal = false
                                            
                                            if QuestionArray.count == 1{
                                                ThemeArray1 = AllThemeArray1[selection-1]
                                                ThemeArray2 = AllThemeArray2[selection-1]
                                                QuestionArray = AllQuestionArray[selection-1]
                                                ThemeidArray = AllThemeidArray[selection-1]
                                                Theme1CounterArray = AllTheme1CounterArray[selection-1]
                                                Theme2CounterArray = AllTheme2CounterArray[selection-1]
                                                
                                                
                                                for number in 0..<reportid.count{
                                                    if let index = ThemeidArray.firstIndex(of: reportid[number].reportid!){
                                                        RemoveArray.append(index)
                                                    }
                                                }
                                                
                                                RemoveArray.sort{$0>$1}
                                                
                                                
                                                for number in 0..<RemoveArray.count{
                                                    
                                                    ThemeArray1.remove(at: RemoveArray[number])
                                                    ThemeArray2.remove(at: RemoveArray[number])
                                                    QuestionArray.remove(at: RemoveArray[number])
                                                    ThemeidArray.remove(at:RemoveArray[number])
                                                    Theme1CounterArray.remove(at:RemoveArray[number])
                                                    Theme2CounterArray.remove(at:RemoveArray[number])
                                                    
                                                }
                                                AlreadyThemeArray[selection-1].removeAll()
                                                RemoveArray.removeAll()
                                            }
                                            
                                            
                                            if Themenumber == QuestionArray.count-1{
                                                Themenumber = -1
                                            }
                                            Themenumber = Themenumber+1
                                            LeftTheme = false
                                            RightTheme = false
                                            
                                            
                                            
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
                    }
                    
                    
//                }
                HStack{
                    Image("Person")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(height:CGFloat(height)/18)
                        .padding(.top,CGFloat(height)/40)
                    
                        
                    
                        
                    
                    Text(memberAll[membernumber])
                        .padding(CGFloat(width)/45)
//                        .frame(width:CGFloat(width)/1.5)
                        .font(.system(size:CGFloat(width)/14))
//                        .background(Color(red:234/255,green:234/255,blue:234/255))
                        .padding(.top,CGFloat(height)/60)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(Color.black)
                }.padding(.trailing,CGFloat(width)/20)

                HStack{
                    Text("Q.")
                        .font(.system(size:CGFloat(width)/15))
                    Text(QuestionArray[Themenumber])
                        .font(.system(size:CGFloat(width)/15))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }.padding(3)
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
                                    .font(.system(size:CGFloat(width)/22))
                                
                            ).multilineTextAlignment(.leading)
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
                                    .font(.system(size:CGFloat(width)/22))
                            ).multilineTextAlignment(.leading)
                    }).shadow(color:.primary.opacity(0.2),radius: 3,x:4,y:4)
                }
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
                        model.updateData(Theme: CategoryArray[selection], id: ThemeidArray[Themenumber], ResultCounter1: ResultCount1+Theme1CounterArray[Themenumber], ResultCounter2: ResultCount2+Theme2CounterArray[Themenumber])
                        
                        if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                            AllTheme1CounterArray[selection-1][index] = ResultCount1 + Theme1CounterArray[Themenumber]}
                        if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                            AllTheme2CounterArray[selection-1][index] = ResultCount2 + Theme2CounterArray[Themenumber]}
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
                            .padding(.top)
                    }
                    if LeftTheme || RightTheme == true{
                        Image("OKButton")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.5)
                            .padding(.top)
                    }
                }.disabled(LeftTheme == false && RightTheme == false)
                    
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
                            .frame(width:CGFloat(width)/1.8)
                            .padding(.trailing)
                        
                    }
                }
                Spacer()
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}
    
struct FourthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView(memberArray: .constant(["回答者の名前1"]),
                   memberArray2: .constant(["回答者の名前2"]),
                   memberAll: .constant(["回答者"]),
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
                   ReportidArray: .constant(["報告済のお題"]),
                   AllThemeArray1: .constant([["お題1全部"]]),
                   AllThemeArray2: .constant([["お題全部"]]),
                   AllQuestionArray: .constant([["質問全部"]]),
                   AllThemeidArray: .constant([["ID全部"]]),
                   Theme1CounterArray: .constant([0]),
                   Theme2CounterArray: .constant([0]),
                   AllTheme1CounterArray: .constant([[0]]),
                   AllTheme2CounterArray: .constant([[0]]),
                   AlreadyThemeArray: .constant([["回答済のお題"]])
        )
    }
}
