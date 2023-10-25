//
//  ChooseTopicView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/27.
//

import SwiftUI
import Firebase
import UIKit

struct ChooseTopicView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTab:Int = 0 //選択されているタブ（みんなのお題で遊ぶとお題を自分で作成）の番号
    @State private var canSwipe:Bool = false
        //タブの切り替えをスワイプで出来なくする判定
    @State private var share = true
        //お題をアップロードするか否かの判定
    @ObservedObject var model = ViewModel()
        //MinorityModelファイル内のクラス
    @FocusState private var isKeybordon : Bool
        //キーボード出現の有無
    @State private var animate = false
        //回転の開始判定
    @State var Loading = false
        //ローディング画面の開始判定
    @State var Decide : Bool = false
        //アラート（アップロードOKか）表示の判定
    @State var RemovenumberArray:[Int] = []
        //回答済+報告済のお題番号を格納
    @State var FirstRemovenumberArray:[Int] = []
        //報告済のお題番号を格納（時間経過でお題が更新された時に適用）
    @State var SelfID = ""
    @State var SelfGenre = ""
    
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
    @Binding var noInternetaccess:Bool
    @Binding var AlreadyThemeArray:[[String]]
    @Binding var ThemeidArray:[String]
    @Binding var Question:String
    @Binding var Theme1 :String
    @Binding var Theme2 :String
    @Binding var AlreadyThemeArray1:[[String]]
    @Binding var AlreadyThemeArray2:[[String]]
    @Binding var AlreadyQuestionArray:[[String]]
    @Binding var AlreadyThemeidArray:[[String]]
    @Binding var AllThemeArray1:[[String]]
    @Binding var AllThemeArray2:[[String]]
    @Binding var AllQuestionArray:[[String]]
    @Binding var AllThemeidArray:[[String]]
    @Binding var Alreadyselection:[Int]
    @Binding var AllreportidArray:[String]
    @Binding var Theme1CounterArray:[Int]
    @Binding var Theme2CounterArray:[Int]
    @Binding var AllTheme1CounterArray:[[Int]]
    @Binding var AllTheme2CounterArray:[[Int]]
    @EnvironmentObject var alreadyselection:AlreadySelection
    
    
    //タブの文字設定
    let list:[String] = ["みんなのお題で遊ぶ","お題を自分で作成"]
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)

        
        
        //本文
        ZStack{
            //ローディング画面に入った場合の処理
            if Loading == true{
                //ローディング画面の背景配置
                    Color(red:237/250,green:236/250,blue:222/250).edgesIgnoringSafeArea(.all)
                    Circle()
                        .frame(width: 250,height: 250)
                        .foregroundColor(.gray)
                        .opacity(0)
                    VStack{
                        
                        //回転する画像配置
                        Image("Loading")
                            .resizable()
                            .frame(width:200,height: 200)
                            .foregroundColor(Color.blue)
                            .offset(y:0)
                            .rotationEffect(.degrees(self.animate ? 360:0))
                            .animation(Animation
                                .timingCurve(1, 1, 1, 1,duration: 3)
                                .repeatForever(autoreverses: false),value:animate
                            )
                            .onAppear(){
                                self.animate = true
                            }
                        Text("読み込み中...")
                            .font(.system(size:20))
                    }
                    .navigationBarHidden(true)
                //インターネットアクセスがない場合の処理。ネットワーク接続が不安定ですというポップ表示を出す。
                    .alert("ネットワーク接続が不安定です",isPresented: $noInternetaccess){
                        Button("再接続"){
                            //再接続ボタンを押した場合のアクション
                                //再びfiredatabaseからお題を読み込む
                                model.getData(Theme:CategoryArray[selection],completion: {
                                    //読み込めた場合の処理。読み込んでから三秒後に始まる。
                                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                        QuestionArray=[]
                                        ThemeArray1=[]
                                        ThemeArray2=[]
                                        ThemeidArray = []
                                        Theme1CounterArray = []
                                        Theme2CounterArray = []
                                        
                                        //各項目を変数に格納する
                                        for number in 0..<model.list.count {
                                            QuestionArray.append(model.list[number].question)
                                            ThemeArray1.append(model.list[number].name)
                                            ThemeArray2.append(model.list[number].notes)
                                            ThemeidArray.append(model.list[number].id)
                                            Theme1CounterArray.append(model.list[number].Count1)
                                            Theme2CounterArray.append(model.list[number].Count2)
                                        }
                                        
                                        //読み込んだお題を取っておくための配列に格納する
                                        for number in 0..<model.list.count {
                        
                                            AllThemeArray1[selection-1].append(model.list[number].name)
                                            AllThemeArray2[selection-1].append(model.list[number].notes)
                                            AllQuestionArray[selection-1].append(model.list[number].question)
                                            AllThemeidArray[selection-1].append(model.list[number].id)
                                            AllTheme1CounterArray[selection-1].append(model.list[number].Count1)
                                            AllTheme2CounterArray[selection-1].append(model.list[number].Count2)
                                            
                                        }
                                        //↓このif文機能してないから消す(ジャンル選択で毎回読み取りする場合は消さない）
                                        if AllreportidArray.count>0 {
                                            for number in 0..<AllreportidArray.count{
                                                if let index = ThemeidArray.firstIndex(of: AllreportidArray[number]){
                                                    FirstRemovenumberArray.append(index)
//                                                    ThemeArray1.remove(at: index)
//                                                    ThemeArray2.remove(at: index)
//                                                    QuestionArray.remove(at: index)
//                                                    ThemeidArray.remove(at:index)
                                                }
                                            }
                                            
                                            FirstRemovenumberArray.sort{$0>$1}
                                            
                                            for number in 0..<FirstRemovenumberArray.count{
                                                ThemeArray1.remove(at:FirstRemovenumberArray[number])
                                                ThemeArray2.remove(at:FirstRemovenumberArray[number])
                                                QuestionArray.remove(at:FirstRemovenumberArray[number])
                                                ThemeidArray.remove(at:FirstRemovenumberArray[number])
                                                Theme1CounterArray.remove(at:FirstRemovenumberArray[number])
                                                Theme2CounterArray.remove(at:FirstRemovenumberArray[number])
                                            }
                                        }
                                        
                                        //出題するお題番号をランダムに決定
                                        Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                        print(QuestionArray)
                                        print(ThemeidArray)
                                        //FourthViewへ遷移
                                        path.append("FourthView")
                                    }
                                //お題を時間内に取得できなかった場合、accessが呼び出され、noInternetaccessがtrueになり、再びアラートが呼び出されループ
                                },access: {noInternetaccess = true})
                            
                        }
                        Button("前の画面に戻る"){
                            
                            animate = false
                            //ChooseTopicViewへ戻る
                            path.append("ChooseTopicView")
                            Loading = false
                            
                        }}
                }
            //これで決定ボタンを押す前の処理
            
            if Loading == false{
                
                VStack(spacing:0){
                    
                    //タブ表示をTopTabViewから持ってくる
                    Divider()
                    TopTabView(list:list,selectedTab: $selectedTab).padding(.bottom,5)
                    TabView(selection:$selectedTab,
                            content: {
                        ZStack {
                            
                            //背景画像配置
                            if height/width < 2{
                                Image("Background9_16")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            if height/width >= 2{
                                Image("Background")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                                
                            }
                            VStack(alignment: .center,spacing:15){
                                //選択肢を配置。tagの後の番号がselectionに渡される。
                                Picker(selection:$selection,label:Text("ジャンル選択1")){
                                    Text("-ジャンルを選択-").tag(0).font(.system(size:CGFloat(width)/20))
                                    Text("恋愛").tag(1).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("スポーツ").tag(2).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("仕事").tag(3).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("芸能").tag(4).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("学校").tag(5).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("美容").tag(6).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("生活").tag(7).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("その他").tag(8).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    
                                }.pickerStyle((WheelPickerStyle())).frame(width:CGFloat(width)/1.3).clipped().padding(.top,CGFloat(height)/10)
            
                                // 「これで決定」ボタンの定義
                                Button(action:{
                                    //ローディング表示を始める
                                    Loading = true
                                    
                                    if alreadyselection.AlreadySelectionArray.firstIndex(of: selection) == nil{
                                        //初めてのジャンルを選択した場合の処理
                                        print("初")
                                        
                                        //firedatabaseからお題を読み込む
                                        model.getData(Theme:CategoryArray[selection],completion: {
                                            //読み込めた場合の処理。読み込んでから三秒後に始まる。
                                            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                                QuestionArray=[]
                                                ThemeArray1=[]
                                                ThemeArray2=[]
                                                ThemeidArray = []
                                                Theme1CounterArray = []
                                                Theme2CounterArray = []
                                                
                                                //各項目を変数に格納する
                                                for number in 0..<model.list.count {
                                                    QuestionArray.append(model.list[number].question)
                                                    ThemeArray1.append(model.list[number].name)
                                                    ThemeArray2.append(model.list[number].notes)
                                                    ThemeidArray.append(model.list[number].id)
                                                    Theme1CounterArray.append(model.list[number].Count1)
                                                    Theme2CounterArray.append(model.list[number].Count2)
                                                }
                                                //読み込んだお題を取っておくための配列に格納する
                                                for number in 0..<model.list.count {
                                                    
                                                    AllThemeArray1[selection-1].append(model.list[number].name)
                                                    AllThemeArray2[selection-1].append(model.list[number].notes)
                                                    AllQuestionArray[selection-1].append(model.list[number].question)
                                                    AllThemeidArray[selection-1].append(model.list[number].id)
                                                    AllTheme1CounterArray[selection-1].append(model.list[number].Count1)
                                                    AllTheme2CounterArray[selection-1].append(model.list[number].Count2)
                                                    
                                                }
                                                
                                                //アプリがバックグラウンドにある状態で10分以上経つ+その前に報告されたお題がある場合、以下が実行される
                                                //読み取ったお題から報告されたお題を取り除く
                                                if AllreportidArray.count>0 {
                                                    for number in 0..<AllreportidArray.count{
                                                        if let index = ThemeidArray.firstIndex(of: AllreportidArray[number]){
                                                            FirstRemovenumberArray.append(index)
//                                                            ThemeArray1.remove(at: index)
//                                                            ThemeArray2.remove(at: index)
//                                                            QuestionArray.remove(at: index)
//                                                            ThemeidArray.remove(at:index)
                                                            
                                                        }
                                                    }
                                                    
                                                    FirstRemovenumberArray.sort{$0>$1}
                                                    
                                                    for number in 0..<FirstRemovenumberArray.count{
                                                        ThemeArray1.remove(at:FirstRemovenumberArray[number])
                                                        ThemeArray2.remove(at:FirstRemovenumberArray[number])
                                                        QuestionArray.remove(at:FirstRemovenumberArray[number])
                                                        ThemeidArray.remove(at:FirstRemovenumberArray[number])
                                                        Theme1CounterArray.remove(at:FirstRemovenumberArray[number])
                                                        Theme2CounterArray.remove(at:FirstRemovenumberArray[number])
                                                    }
                                                }
                                                
                                                //出題するお題番号をランダムに決定
                                                Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                                print(QuestionArray)
                                                print(ThemeidArray)
                                                //FourthViewへ遷移
                                                path.append("FourthView")
                                                alreadyselection.AlreadySelectionArray.append(selection)
                                                print(alreadyselection.AlreadySelectionArray)
                                                
                                            }
                                            //お題を時間内に取得できなかった場合、accessが呼び出され、noInternetaccessがtrueになり、再びアラートが呼び出されループ
                                        },access: {noInternetaccess = true})
                                        
                                    }
                                    
                                    else {
                                        //二回目以降のジャンルを選択した場合の処理
                                        print("二回目")
                                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                            //以前に回答済+報告されたお題番号を、ジャンル内で検出しRemovenumberArrayに格納
                                            for number in 0..<AlreadyThemeArray[selection-1].count{
                                                if let index = AllThemeidArray[selection-1].firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                                    RemovenumberArray.append(index)
                                                    
                                                }
                                            }
                                            //正確にお題を除去できるようRemovenumberArrayを昇順に並び替える
                                            RemovenumberArray.sort{$0>$1}
                                            
                                            ThemeArray1 = AllThemeArray1[selection-1]
                                            ThemeArray2 = AllThemeArray2[selection-1]
                                            QuestionArray = AllQuestionArray[selection-1]
                                            ThemeidArray = AllThemeidArray[selection-1]
                                            Theme1CounterArray = AllTheme1CounterArray[selection-1]
                                            Theme2CounterArray = AllTheme2CounterArray[selection-1]
                                            
                                            //回答済+報告済のお題を取り除く
                                            for number in 0..<RemovenumberArray.count{
                                                
                                                    ThemeArray1.remove(at: RemovenumberArray[number])
                                                    ThemeArray2.remove(at: RemovenumberArray[number])
                                                    QuestionArray.remove(at: RemovenumberArray[number])
                                                    ThemeidArray.remove(at: RemovenumberArray[number])
                                                Theme1CounterArray.remove(at:RemovenumberArray[number])
                                                Theme2CounterArray.remove(at:RemovenumberArray[number])
                                            }
                                            
                                            print(QuestionArray)
                                            print(ThemeidArray)
                                            
                                            //出題するお題番号をランダムに決定
                                            Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                            path.append("FourthView")
                                        }
                                    }
                                    
                                    
                                }) {
                                    //selectionが0つまり、ジャンルが選択されていないときは、ボタンがグレーかつ押せなくする
                                    if selection == 0{
                                        Image("DecideTheme_grey")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:CGFloat(width)/1.5)
                                            .padding(.bottom)
                                    }
                                    if selection > 0 {
                                        Image("DecideTheme")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:CGFloat(width)/1.5)
                                            .padding(.bottom)
                                    }
                                }.disabled(selection == 0)
                                Spacer()
                            }
                        }.padding(.top,CGFloat(height)/7)
                        
                            .tag(0)
                        //以上でみんなのお題で遊ぶの内容終了
                        
                        
                        //↓ここからお題を自分で作成の内容
                        ZStack {
                            
                            // 背景画像配置
                            if height/width < 2{
                                Image("Background9_16")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                            }
                            if height/width >= 2{
                                Image("Background")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .edgesIgnoringSafeArea(.all)
                                
                            }
                            
                            VStack(alignment: .center,spacing:15) {
                                //選択肢を配置。tagの後の番号がselectionに渡される。selectionの変数がみんなのお題で遊ぶのViewと同じであるため、連動している。
                                Picker(selection:$selection,label:Text("ジャンル選択1")){
                                    Text("-ジャンルを選択-").tag(0).font(.system(size:CGFloat(width)/20))
                                    Text("恋愛").tag(1).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("スポーツ").tag(2).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("仕事").tag(3).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("芸能").tag(4).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("学校").tag(5).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("美容").tag(6).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("生活").tag(7).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    Text("その他").tag(8).font(.system(size:CGFloat(width)/15)).fontWeight(.bold)
                                    
                                }.pickerStyle((WheelPickerStyle())).frame(width:CGFloat(width)/1.3,height: CGFloat(height)/10).clipped().padding(.top,CGFloat(height)/8)
                                
                                
                                //質問入力用のテキストボックス配置
                                HStack(alignment: .center){
//                                    Text("Q.")
//                                        .font(.system(size:CGFloat(width)/10))
//                                        .shadow(color:.primary.opacity(0.3),radius: 3,x:4,y:4)
                                    ZStack{
                                        TextEditor(text:$Question)
                                            .frame(width:CGFloat(width)/1.4,height: CGFloat(height)/14)
                                            .focused($isKeybordon)
                                            .multilineTextAlignment(.leading)
                                            
                                            .shadow(color:.primary.opacity(0.3),radius: 3,x:4,y:4)
                                            .font(.system(size:CGFloat(width)/25))
                                        
                                        if Question.isEmpty{
                                            Text("質問を入力してください。")
                                                .foregroundColor(Color(uiColor: .placeholderText))
                                                .allowsHitTesting(false)
                                                .padding(.bottom,CGFloat(height)/30)
                                                .padding(.trailing,CGFloat(width)/4)
                                                .font(.system(size:CGFloat(width)/25))
                                        }
                                    }
                                    
                                    
                                }
                                // お題入力用のテキストボックス追加
                                HStack(alignment: .top,spacing:25) {
                                    ZStack{
                                        //お題1のテキストボックス
                                        TextEditor(text:$Theme1)
                                            .frame(width:CGFloat(width)/2.3,height: CGFloat(height)/3)
                                            .padding(.leading, 30.0)
                                            .focused($isKeybordon)
                                            .multilineTextAlignment(.leading)
                                            .shadow(color:.primary.opacity(0.1),radius: 3,x:4,y:4)
                                            .font(.system(size:CGFloat(width)/25))
                                        
                                        if Theme1.isEmpty{
                                            Text("選択肢1を入力してください。")
                                                .foregroundColor(Color(uiColor: .placeholderText))
                                                .allowsHitTesting(false)
                                                .padding(.bottom,CGFloat(height)/3.7)
                                                .padding(.leading,CGFloat(width)/19)
                                                .font(.system(size:CGFloat(width)/25))
                                        }
                                    }
                                    //お題2のテキストボックス
                                    ZStack{
                                        TextEditor(text:$Theme2)
                                            .frame(width:CGFloat(width)/2.3,height: CGFloat(height)/3)
                                            .padding(.trailing, 30.0)
                                            .focused($isKeybordon)
                                            .multilineTextAlignment(.leading)
                                            .shadow(color:.primary.opacity(0.1),radius: 3,x:4,y:4)
                                            .font(.system(size:CGFloat(width)/25))
                                        
                                        if Theme2.isEmpty{
                                            Text("選択肢2を入力してください。")
                                                .foregroundColor(Color(uiColor: .placeholderText))
                                                .allowsHitTesting(false)
                                                .padding(.bottom,CGFloat(height)/3.7)
                                                .padding(.trailing,CGFloat(width)/8.5)
                                                .font(.system(size:CGFloat(width)/25))
                                        }
                                        
                                    }
                                }
                                
                                //確定ボタンの配置
                                Button(action:{
                                    Decide = true
                                }
                                ) {
                                    //ジャンルが選択されているかつ、すべてのテキストボックスに文字が入っている場合のみボタンを押せるようになっている。
                                    if (selection == 0 || Question == "" || Theme1 == "" || Theme2 == "") {
                                        Image("DecideGrey")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:CGFloat(width)/2.0)
                                    } else {
                                        Image("Decide")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:CGFloat(width)/2.0)
                                    }
                                }
                                .disabled(selection == 0 || Question == "" || Theme1 == "" || Theme2 == "")
                                .padding()
                                
                                
                                //確定ボタンを押したら以下のアラートが表示される。
                                .alert("作成したお題をオンラインで\n公開しますか？",isPresented: $Decide){
                                    Button("はい"){
                                        //質問、お題1、お題2をfirebaseにアップロード
                                        SelfID = model.addData(Theme:CategoryArray[selection],question: Question,name: Theme1, notes: Theme2)
                                        print(SelfID)
                                        let newThemeModel = ThemeModel(context:context)
                                        newThemeModel.ownid = SelfID
                                        newThemeModel.genre = CategoryArray[selection]
                                        try? context.save()
                                        path.append("OfflineView")
                                            
                                    }
                                    Button("いいえ"){
                                        path.append("OfflineView")
                                    }
                                    Button("お題を修正"){}
                                }
                                Spacer()
                            }.ignoresSafeArea(.keyboard,edges: .bottom)
                                .onTapGesture {
                                    isKeybordon = false
                                }
                            
                        }
                        .tag(1)
                        //以上でお題を自分で作成の内容終わり
                    })
                    //タブビューにするために必要
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }
                //ヘッダーの設定
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("出題方法を選択")
                .edgesIgnoringSafeArea(.bottom )
            }
        }.navigationBarBackButtonHidden(true)
        //左上に配置される名前登録に戻るボタンの配置
            .toolbar{
                if Loading == false{
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(
                            action:{
                                //SecondViewに戻る
                                path=NavigationPath(["SecondView"])
                            }) {
                                HStack{
                                    Image(systemName: "arrow.backward")
                                        .font(.system(size: 17,weight:.medium))
                                    Text("名前登録").font(.system(size:14))
                                }
                            }
                            
                    }
                }
            }
            
            
        }
    }

struct ChooseTopicView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTopicView(memberArray: .constant(["回答者の名前1"]),
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
                        noInternetaccess: .constant(true),
                        AlreadyThemeArray: .constant([["回答済のお題"]]),
                        ThemeidArray:.constant(["お題ID"]),
                        Question: .constant(""),
                        Theme1:.constant(""),
                        Theme2:.constant(""),
                        AlreadyThemeArray1: .constant([["お題1全部"]]),
                        AlreadyThemeArray2: .constant([["お題全部"]]),
                        AlreadyQuestionArray: .constant([["a"]]),
                        AlreadyThemeidArray: .constant([["ID"]]),
                        AllThemeArray1: .constant([["お題1全部"]]),
                        AllThemeArray2: .constant([["お題全部"]]),
                        AllQuestionArray: .constant([["質問全部"]]),
                        AllThemeidArray: .constant([["ID全部"]]),
                        Alreadyselection: .constant([0]),
                        AllreportidArray: .constant(["報告済のお題全部"]),
                        Theme1CounterArray: .constant([0]),
                        Theme2CounterArray: .constant([0]),
                        AllTheme1CounterArray: .constant([[0]]),
                        AllTheme2CounterArray: .constant([[0]])
                        )
    }
}
