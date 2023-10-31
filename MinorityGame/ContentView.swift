//
//  ContentView.swift
//  Helloworld
//
//  Created by kazuhiro hirata on 2023/08/18.



import SwiftUI
import Foundation
import Combine
import UIKit
import CoreData
import Firebase



struct ContentView: View {
    //被管理オブジェクトコンテキスト(ManagedObjectContext)の取得
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var model = ViewModel()
    //データベースよりデータを取得
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ThemeModel.ownid,ascending: true)],animation: .default)
    private var items: FetchedResults<ThemeModel>
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var alreadyselection : AlreadySelection
    @State var inactivetime = 0
    @State var activetime = 0
    @State var timeout = false
    @State private var path = NavigationPath()
    
    //--
    @State var memberAll:[String] = []                  //メンバー全員の名前を入れる（一列目+二列目)
    @State var memberArray:[String]  = [""]             //一列目のメンバーの名前を入れる
    @State var memberArray2:[String] = []               //二列目のメンバーの名前を入れる
    @State var ButtonCount           = 1                //メンバーの数
    @State var anonymous = false                        //匿名表示の選択
    @State var CategoryArray:[String]  =                //ジャンルリスト
    ["","恋愛","スポーツ","仕事","芸能","学校","美容","生活","その他"]
    @State var selection          = 0                   //ジャンルの番号（恋愛は1,スポーツは2)
    @State var ThemeArray1:[String] = []                //お題1の配列
    @State var ThemeArray2:[String] = []                //お題2の配列
    @State var QuestionArray:[String] = []              //質問の配列
    @State var Themenumber = 0                          //ジャンル内のお題の番号
    @State var ResultMemberArray1:[String]=[]           //お題1を選択した人を格納する配列
    @State var ResultMemberArray2:[String]=[]           //お題2を選択した人を格納する配列
    @State var ONlineResultShow_red : Bool = false      //結果発表画面で少数派のお題の色を変える時に使う
    @State var ONlineResultShow_white : Bool = false    //結果発表画面で少数派のお題の色を決める時に使う
    @State var OfflineResultShow_red : Bool = false     //結果発表画面で少数派のお題の色を決める時に使う（自分でお題作成時）
    @State var OfflineResultShow_white:Bool = false     //結果発表画面で少数派のお題の色を決める時に使う（自分でお題作成時）
    @State var ResultCount1 = 0                         //お題1の回答数
    @State var ResultCount2 = 0                         //お題2の回答数
    @State var noInternetaccess = false                 //インターネットアクセスの有無判定
    @State var Question = ""                            //質問（自分でお題作成時）
    @State var Theme1 = ""                              //お題1(自分でお題作成時）
    @State var Theme2 = ""                              //お題2(自分でお題作成時）
    @State var AlradyThemeArray:[[String]] = [[],[],[],[]] //回答済+報告済のお題全て
    @State var ThemeidArray:[String] = []               //お題のIDの配列
    @State private var ReportidArray:[String]=[]        //報告されたお題を一時的に格納
    @State var AlreadyThemeArray1:[[String]] = [[],[],[],[]] //各ジャンルのお題1全部（回答されたお題1を減らしていく）
    @State var AlreadyThemeArray2:[[String]] = [[],[],[],[]] //各ジャンルのお題2全部（回答されたお題2を減らしていく）
    @State var Alreadyselection :[Int] = []             //選択されたジャンル番号を格納
    @State var AlreadyQuestionArray:[[String]] = [[],[],[],[]]//各ジャンルの質問（回答された質問を減らしていく）
    @State var AlreadyThemeidArray:[[String]] = [[],[],[],[]]//お題IDの配列（回答されたお題IDを減らしていく）
    
    @State var AllThemeArray1:[[String]] = [[],[],[],[]]   //各ジャンルのお題1を全部格納（中身は減らさない）
    @State var AllThemeArray2:[[String]] = [[],[],[],[]]   //各ジャンルのお題2を全部格納（中身は減らさない）
    @State var AllQuestionArray:[[String]] = [[],[],[],[]] //各ジャンルの質問を全部格納（中身は減らさない）
    @State var AllThemeidArray:[[String]] = [[],[],[],[]]  //各ジャンルのお題IDを全部格納（中身は減らさない）
    @State var AllReportidArray:[String] = []           //報告されたお題IDを全部格納
    @State var Theme1CounterArray:[Int] = []            //各お題1の全国投票数を格納
    @State var Theme2CounterArray:[Int] = []            //各お題2の全国投票数を格納
    @State var AllTheme1CounterArray:[[Int]] = [[],[],[],[]]         //各お題1の全国投票数を格納（中身は減らさない）
    @State var AllTheme2CounterArray:[[Int]] = [[],[],[],[]]         //各お題2の全国投票数を格納（中身は減らさない）
    @State var OwnTheme1Array:[String] = []
    @State var OwnTheme2Array:[String] = []
    @State var OwnQuestionArray:[String] = []
    @State var OwnCount1Array:[Int] = []
    @State var OwnCount2Array:[Int] = []
    @State var Loading_Own = false
     //--
    
    
    var body: some View {
        //画面のサイズ取得
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        
        //本文
        NavigationStack(path: $path) {
            ZStack {

                    // 背景指定(縦横比が二倍以上のものと、縦横比が二倍以下のiPhoneSEなどで背景画像を変えている）
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
                        // タイトル画像配置
                        Image("minority")
                            .resizable(capInsets: EdgeInsets())
                            .scaledToFit()
                            .frame(width:CGFloat(width)/1.1,height:CGFloat(height)/2)
                            .padding()
                        
                        //PLAYボタン配置
                        Button(action:{path.append("SecondView")}) {
                            Image("PLAY")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width:CGFloat(width)/1.3)
                        }
                        
                        //ContentViewで定義した変数の中で使用する変数を各Viewへ受け渡す
                        .navigationDestination(for: String.self) {route in
                            switch route{
                                
                            case "OwnThemeView":
                                OwnThemeView(
                                    OwnQuestionArray:$OwnQuestionArray,
                                    OwnTheme1Array:$OwnTheme1Array,
                                    OwnTheme2Array:$OwnTheme2Array,
                                    OwnCount1Array:$OwnCount1Array,
                                    OwnCount2Array:$OwnCount2Array,
                                Loading_Own: $Loading_Own)
                            case "SecondView":
                                SecondView(
                                    memberArray:$memberArray,
                                    memberArray2:$memberArray2,
                                    memberAll: $memberAll,
                                    ButtonCount: $ButtonCount,
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
                                    ReportidArray: $ReportidArray,
                                    AllThemeidArray: $AllThemeidArray,
                                    Theme1CounterArray:$Theme1CounterArray,
                                    Theme2CounterArray:$Theme2CounterArray,
                                    AllTheme1CounterArray:$AllTheme1CounterArray,
                                    AllTheme2CounterArray:$AllTheme2CounterArray)
                            case "ResultView":
                                ResultView(
                                    memberArray:$memberArray,
                                    memberArray2:$memberArray2,
                                    memberAll: $memberAll,
                                    ButtonCount: $ButtonCount,
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
                                    AllReportidArray: $AllReportidArray,
                                    Theme1CounterArray:$Theme1CounterArray,
                                    Theme2CounterArray:$Theme2CounterArray,
                                    AllTheme1CounterArray:$AllTheme1CounterArray,
                                    AllTheme2CounterArray:$AllTheme2CounterArray)
                                
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
                                    Alreadyselection:$Alreadyselection,
                                    AllreportidArray: $AllReportidArray,
                                    Theme1CounterArray:$Theme1CounterArray,
                                    Theme2CounterArray:$Theme2CounterArray,
                                    AllTheme1CounterArray:$AllTheme1CounterArray,
                                    AllTheme2CounterArray:$AllTheme2CounterArray
                                )
                                
                            default:
                                ContentView()
                            }
                        }
                        
                        Button(action:{
                            Loading_Own = true
                            OwnTheme1Array.removeAll()
                            OwnTheme2Array.removeAll()
                            OwnQuestionArray.removeAll()
                            OwnCount1Array.removeAll()
                            OwnCount2Array.removeAll()
                            let db = Firestore.firestore()
                            for number in 0..<items.count {
                                db.collection(items[number].genre!).document(items[number].ownid!).getDocument { (document,error) in
                                    guard error == nil else{
                                        print("error")
                                        return
                                    }
                                    if let document = document,document.exists{
                                        let data = document.data()
                                        if let data = data{
                                            OwnTheme1Array.append(data["Theme1"] as? String ?? "")
                                            OwnTheme2Array.append(data["Theme2"] as? String ?? "")
                                            OwnQuestionArray.append(data["Question"] as? String ?? "")
                                            OwnCount1Array.append(data["Average1"] as? Int ?? Int())
                                            OwnCount2Array.append(data["Average2"] as? Int ?? Int())
                                        }}
                                    
                                }
                            }
                                                    
                            //                        print(OwnTheme2Array)
                            //                        print(OwnQuestionArray)
                            //                        print(OwnCount1Array)
                            //                        print(OwnCount2Array)
                            path.append("OwnThemeView")
                            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                Loading_Own = false
                            }
                        }) {
                            Image("OwnTheme")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width:CGFloat(width)/1.3)
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
        .onChange(of:scenePhase) {
            phase in
            switch phase {
            case .active:
                activetime = 525600*(Calendar.current.component(.year, from:Date()))+43800*(Calendar.current.component(.month, from:Date()))+1440*(Calendar.current.component(.day, from:Date()))+60*(Calendar.current.component(.month, from:Date()))+(Calendar.current.component(.minute, from:Date()))
                print(activetime)
                print(activetime-inactivetime)
                        if activetime-inactivetime > 1 {
                            alreadyselection.AlreadySelectionArray.removeAll()
                        }
                print(alreadyselection.AlreadySelectionArray)
            case .inactive:
                print("inactive")
            case .background:
                inactivetime = 525600*(Calendar.current.component(.year, from:Date()))+43800*(Calendar.current.component(.month, from:Date()))+1440*(Calendar.current.component(.day, from:Date()))+60*(Calendar.current.component(.month, from:Date()))+(Calendar.current.component(.minute, from:Date()))
                print(inactivetime)
            @unknown default:
                print("@unknown")
            }
        }
    }
        
}
           
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AlreadySelection())
    }
}
