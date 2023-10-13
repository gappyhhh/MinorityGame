//
//  ResultView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/05.
//

import SwiftUI
import Firebase

struct ResultView: View {
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
    @Binding var AlreadyThemeArray:[[String]]
    @Binding var ThemeidArray:[String]
    @Binding var ReportidArray:[String]
    @Binding var AllThemeArray1:[[String]]
    @Binding var AllThemeArray2:[[String]]
    @Binding var AllQuestionArray:[[String]]
    @Binding var AllThemeidArray:[[String]]
    @Binding var AllReportidArray:[String]
    
    @State var isPresented: Bool = false
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
                    Text(QuestionArray[Themenumber])
                        .font(.system(size:CGFloat(width)/18))
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
                Spacer()
                HStack(alignment: .bottom,spacing:20){
                    VStack{
                        //                        Text(String(ResultCount1))
                        //                            .font(.system(size:CGFloat(height)/20))
                        Text(ThemeArray1[Themenumber])
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(ONlineResultShow_red ? .white:.red)
                            .font(.system(size:CGFloat(height)/45))
//                        if anonymous == false {
                            ForEach(0..<ResultMemberArray1.count, id:\.self ) {
                                index in Text(ResultMemberArray1[index])
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
                        //                            .font(.system(size:CGFloat(height)/20))
                        Text(ThemeArray2[Themenumber])
                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/7)
                            .foregroundColor(Color.black)
                            .background(ONlineResultShow_white ? .white:.red)
                            .font(.system(size:CGFloat(height)/45))
//                        if anonymous == false {
                            ForEach(0..<ResultMemberArray2.count, id:\.self ) {
                                index in Text(ResultMemberArray2[index])
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
                
                
                HStack(alignment: .center,spacing:0){
                    // 「ジャンル選択へ」ボタンの定義
                    Button(action:{
                        
                        ResultMemberArray1.removeAll()
                        ResultMemberArray2.removeAll()
                        AlreadyThemeArray[selection-1].append(ThemeidArray[Themenumber])
                        for num in 0..<ReportidArray.count{
                            AlreadyThemeArray[selection-1].append(ReportidArray[num])
                            AllReportidArray.append(ReportidArray[num])
                        }
                        print(AllThemeidArray[selection-1].count,AlreadyThemeArray[selection-1].count)
                        if AlreadyThemeArray[selection-1].count == AllThemeidArray[selection-1].count{
                            AlreadyThemeArray[selection-1] = AllReportidArray
                        }
                        print(AllThemeidArray)
                        print(AlreadyThemeArray)
                        
                        ReportidArray = []
                        selection = 0
                        path.append("ChooseTopicView")
                    }) {
                        Image("SelectGanre")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/2)
                    }.padding(.bottom)
                    
                    // 「次の問題へ」ボタンの定義
                    Button(action:{
                        
                        
                        ResultMemberArray1.removeAll()
                        ResultMemberArray2.removeAll()
                        AlreadyThemeArray[selection-1].append(ThemeidArray[Themenumber])
                        
                        for num in 0..<ReportidArray.count{
                            AlreadyThemeArray[selection-1].append(ReportidArray[num])
                            AllReportidArray.append(ReportidArray[num])
                        }
                        print(AlreadyThemeArray)
                        print(AllReportidArray)
                        for number in 0..<AlreadyThemeArray[selection-1].count{
                            if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                ThemeArray1.remove(at: index)
                                ThemeArray2.remove(at: index)
                                QuestionArray.remove(at: index)
                                ThemeidArray.remove(at:index)
                            }
                        }
                        if QuestionArray.isEmpty == true{
                            ThemeArray1 = AllThemeArray1[selection-1]
                            ThemeArray2 = AllThemeArray2[selection-1]
                            QuestionArray = AllQuestionArray[selection-1]
                            ThemeidArray = AllThemeidArray[selection-1]
                            
                            for number in 0..<AllReportidArray.count{
                                if let index = ThemeidArray.firstIndex(of: AllReportidArray[number]){
                                    ThemeArray1.remove(at: index)
                                    ThemeArray2.remove(at: index)
                                    QuestionArray.remove(at: index)
                                    ThemeidArray.remove(at:index)
                                }
                            }
                            AlreadyThemeArray[selection-1] = AllReportidArray
                        }
                        Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                        
                        ReportidArray = []
                        print(QuestionArray)
                        path.append("FourthView")
                    }) {
                        Image("NextTheme")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/2)
                    }.padding(.bottom)
                }
                    
//                    Button(action:{
//
//                        path.append("ChooseTopicView")
//                        ResultMemberArray1.removeAll()
//                        ResultMemberArray2.removeAll()
//                        AlreadyThemeArray.append(ThemeidArray[Themenumber])
//                        for num in 0..<ReportidArray.count{
//                            AlreadyThemeArray.append(ReportidArray[num])
//                        }
//                        print(AlreadyThemeArray)
//                        ReportidArray = []
//                        selection = 0
//                    }) {
//                        Image("NextTheme")
//                            .renderingMode(.original)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width:CGFloat(width)/2)
//                    }
            }
                }.navigationBarBackButtonHidden(true)
//            .edgesIgnoringSafeArea(.bottom)
//            .toolbar{
//
//                    ToolbarItem(placement: .navigationBarLeading){
//                        Button(
//                            action:{
//                                path=NavigationPath(["SecondView"])
//                            }) {
//                                HStack{
//                                    Image(systemName: "arrow.backward")
//                                        .font(.system(size: 17,weight:.medium))
//                                    Text("ジャンル選択へ").font(.system(size:14))
//                                }
//                            }
//
//                    }
//
//            }
            }
        }

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(memberArray: .constant(["回答者の名前1"]),
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
                   AlreadyThemeArray: .constant([["回答済みのお題"]]),
                   ThemeidArray: .constant(["お題ID"]),
                   ReportidArray: .constant(["報告済みのお題"]),
                   AllThemeArray1: .constant([["お題1全部"]]),
                   AllThemeArray2: .constant([["お題全部"]]),
                   AllQuestionArray: .constant([["質問全部"]]),
                   AllThemeidArray: .constant([["ID全部"]]),
                   AllReportidArray: .constant(["報告済みのお題全部"])
                   
        )
    }
}
