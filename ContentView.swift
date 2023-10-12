//
//  ContentView.swift
//  Helloworld
//
//  Created by kazuhiro hirata on 2023/08/18.
//

import SwiftUI
import Foundation
import Combine
import UIKit



struct ContentView: View {
    @State var isPresented:Bool = false
    //    @State var path : [String] = []
    @State private var path = NavigationPath()
    
    //--
    @State var memberAll:[String] = []
    @State var memberArray:[String]  = [""]
    @State var memberArray2:[String] = []
    @State var ButtonCount           = 1
    @State var anonymousWhich = false
    @State var anonymous = false
    @State var CategoryArray:[String]  = ["","恋愛","スポーツ","仕事","芸能","学校","美容","生活","その他"]
    @State var selection          = 0
    @State var ThemeArray1:[String] = []
    @State var ThemeArray2:[String] = []
    @State var QuestionArray:[String] = []
    @State var Themenumber = 0
    @State var ResultMemberArray1:[String]=[]
    @State var ResultMemberArray2:[String]=[]
    @State var ONlineResultShow_red : Bool = false
    @State var ONlineResultShow_white : Bool = false
    @State var OfflineResultShow_red : Bool = false
    @State var OfflineResultShow_white:Bool = false
    @State var ResultCount1 = 0
    @State var ResultCount2 = 0
    @State var noInternetaccess = false
    @State var Question = ""
    @State var Theme1 = ""
    @State var Theme2 = ""
    @State var AlradyThemeArray:[[String]] = [[],[],[]]
    @State var ThemeidArray:[String] = []
    @State var ThemeUploadWhich = false
    @State private var ReportidArray:[String]=[]
    @State var AlreadyThemeArray1:[[String]] = [[],[],[]]
    @State var AlreadyThemeArray2:[[String]] = [[],[],[]]
    @State var Alreadyselection :[Int] = []
    @State var AlreadyQuestionArray:[[String]] = [[],[],[]]
    @State var AlreadyThemeidArray:[[String]] = [[],[],[]]
    
    @State var AllThemeArray1:[[String]] = [[],[],[]]
    @State var AllThemeArray2:[[String]] = [[],[],[]]
    @State var AllQuestionArray:[[String]] = [[],[],[]]
    @State var AllThemeidArray:[[String]] = [[],[],[]]
    @State var AllReportidArray:[String] = []
    //--
    
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        NavigationStack(path: $path) {
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
                    // タイトル画像の定義
                    Image("minority")
                        .resizable(capInsets: EdgeInsets())
                        .scaledToFit()
                        .frame(width:CGFloat(width)/1.1,height:CGFloat(height)/2)
                        .padding()
                    
                    Button(action:{path.append("SecondView")}) {
                        Image("PLAY")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.3)
                    }
                    .navigationDestination(for: String.self) {route in
                        switch route{
                        case "SecondView":
                            SecondView(
                                memberArray:$memberArray,
                                memberArray2:$memberArray2,
                                memberAll: $memberAll,
                                ButtonCount: $ButtonCount,
                                anonymousWhich:$anonymousWhich,
                                anonymous:$anonymous,
                                path:$path,
                                ThemeArray1: $ThemeArray1,
                                ThemeArray2: $ThemeArray2,
                                CategoryArray:$CategoryArray,
                                selection:$selection,
                                QuestionArray:$QuestionArray,
                                Themenumber:$Themenumber,
                                ONlineResultShow_red: $ONlineResultShow_red,
                                ONlineResultShow_white:$ONlineResultShow_white,
                                ResultMemberArray1:$ResultMemberArray1,
                                ResultMemberArray2:$ResultMemberArray2,
                                ResultCount1:$ResultCount1,
                                ResultCount2:$ResultCount2)
                        case "FourthView":
                            FourthView(
                                memberArray:$memberArray,
                                memberArray2:$memberArray2,
                                memberAll: $memberAll,
                                ButtonCount: $ButtonCount,
                                anonymousWhich:$anonymousWhich,
                                anonymous:$anonymous,
                                path:$path,
                                ThemeArray1: $ThemeArray1,
                                ThemeArray2: $ThemeArray2,
                                CategoryArray:$CategoryArray,
                                selection:$selection,
                                QuestionArray:$QuestionArray,
                                Themenumber:$Themenumber,
                                ONlineResultShow_red: $ONlineResultShow_red,
                                ONlineResultShow_white:$ONlineResultShow_white,
                                ResultMemberArray1:$ResultMemberArray1,
                                ResultMemberArray2:$ResultMemberArray2,
                                ResultCount1:$ResultCount1,
                                ResultCount2:$ResultCount2,
                            ThemeidArray: $ThemeidArray,
                            ReportidArray: $ReportidArray)
                        case "ResultView":
                            ResultView(
                                memberArray:$memberArray,
                                memberArray2:$memberArray2,
                                memberAll: $memberAll,
                                ButtonCount: $ButtonCount,
                                anonymousWhich:$anonymousWhich,
                                anonymous:$anonymous,
                                path:$path,
                                ThemeArray1: $ThemeArray1,
                                ThemeArray2: $ThemeArray2,
                                CategoryArray:$CategoryArray,
                                selection:$selection,
                                QuestionArray:$QuestionArray,
                                Themenumber:$Themenumber,
                                ONlineResultShow_red: $ONlineResultShow_red,
                                ONlineResultShow_white:$ONlineResultShow_white,
                                ResultMemberArray1:$ResultMemberArray1,
                                ResultMemberArray2:$ResultMemberArray2,
                                ResultCount1:$ResultCount1,
                                ResultCount2:$ResultCount2,
                            AlreadyThemeArray: $AlradyThemeArray,
                            ThemeidArray: $ThemeidArray,
                            ReportidArray: $ReportidArray,
                                AllThemeArray1: $AllThemeArray1,
                                AllThemeArray2: $AllThemeArray2,
                                AllQuestionArray:$AllQuestionArray,
                                AllThemeidArray: $AllThemeidArray,
                            AllReportidArray: $AllReportidArray)
                            
                        case "OfflineView":
                            OfflineView(OfflineResultShow_red: $OfflineResultShow_red,OfflineResultShow_white:$OfflineResultShow_white,ResultMemberArray1: $ResultMemberArray1, ResultMemberArray2: $ResultMemberArray2, memberAll: $memberAll, memberArray: $memberArray, memberArray2: $memberArray2, Question: $Question, Theme1: $Theme1, Theme2: $Theme2, selection: $selection, CategoryArray: $CategoryArray, anonymous: $anonymous, path: $path, ResultCount1: $ResultCount1, ResultCount2: $ResultCount2)
                            
                        case "OfflineResultView":
                            OfflineResultView(Question: $Question, memberAll: $memberAll, memberArray: $memberArray, memberArray2: $memberArray2, Theme1: $Theme1, Theme2: $Theme2, selection: $selection, CategoryArray: $CategoryArray, ResultCount1: $ResultCount1, ResultCount2: $ResultCount2, OfflineResultShow_red: $OfflineResultShow_red, OfflineResultShow_white: $OfflineResultShow_white, anonymous: $anonymous, ResultMemberArray1: $ResultMemberArray1, ResultMemberArray2: $ResultMemberArray2, path: $path)
                            
                        case "ChooseTopicView":
                            ChooseTopicView(
                                memberArray:$memberArray,
                                memberArray2:$memberArray2,
                                memberAll: $memberAll,
                                ButtonCount: $ButtonCount,
                                anonymousWhich:$anonymousWhich,
                                anonymous:$anonymous,
                                path:$path,
                                ThemeArray1: $ThemeArray1,
                                ThemeArray2: $ThemeArray2,
                                CategoryArray:$CategoryArray,
                                selection:$selection,
                                QuestionArray:$QuestionArray,
                                Themenumber:$Themenumber,
                                ONlineResultShow_red: $ONlineResultShow_red,
                                ONlineResultShow_white:$ONlineResultShow_white,
                                ResultMemberArray1:$ResultMemberArray1,
                                ResultMemberArray2:$ResultMemberArray2,
                                ResultCount1:$ResultCount1,
                                ResultCount2:$ResultCount2,
                            noInternetaccess: $noInternetaccess,
                            AlreadyThemeArray: $AlradyThemeArray,
                            ThemeidArray: $ThemeidArray,
                                ThemeUploadWhich: $ThemeUploadWhich,
                                Question: $Question,
                                Theme1: $Theme1,
                                Theme2: $Theme2,
                                AlreadyThemeArray1: $AlreadyThemeArray1,
                                AlreadyThemeArray2: $AlreadyThemeArray2,
                                AlreadyQuestionArray:$AlreadyQuestionArray,
                                AlreadyThemeidArray: $AlreadyThemeidArray,
                                AllThemeArray1: $AllThemeArray1,
                                AllThemeArray2: $AllThemeArray2,
                                AllQuestionArray:$AllQuestionArray,
                                AllThemeidArray: $AllThemeidArray,
                                Alreadyselection:$Alreadyselection
                            )
                            
                        default:
                            ContentView()
                        }
                    }
                    
                    
                    // 「遊び方」ボタンの定義
                    Button(action:{path.append("ChooseTopicView")
                        print(height)
                    }) {
                        Image("Howto")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.3)
                    }
                }
            }
        }
    }
}
           
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
