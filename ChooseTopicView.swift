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
    
    @State private var selectedTab:Int = 0
    @State private var canSwipe:Bool = false
    @State private var share = true
    @ObservedObject var model = ViewModel()
    @FocusState private var isKeybordon : Bool
    @State var DecideTheme:Bool        = false
    @State var Inputself:Bool        = false
    @State private var animate = false
    @State var Themedata = true
    @State var sign = false
    @State var Loading = false
    @State var Decide : Bool = false
    @State var RemovenumberArray:[Int] = []
    @Binding var memberArray:[String]
    @Binding var memberArray2:[String]
    @Binding var memberAll:[String]
    @Binding var ButtonCount:Int
    @Binding var anonymousWhich:Bool
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
    @Binding var ThemeUploadWhich:Bool
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
    
    let list:[String] = ["みんなのお題で遊ぶ","お題を自分で作成"]
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)

        
        

        ZStack{
            if Loading == true{
                    Color(red:237/250,green:236/250,blue:222/250).edgesIgnoringSafeArea(.all)
                    Circle()
                        .frame(width: 250,height: 250)
                        .foregroundColor(.gray)
                        .opacity(0)
                    VStack{
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
                    .alert("ネットワーク接続が不安定です",isPresented: $noInternetaccess){
                        Button("再接続"){

                                model.getData(Theme:CategoryArray[selection],completion: {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                        QuestionArray=[]
                                        ThemeArray1=[]
                                        ThemeArray2=[]
                                        ThemeidArray = []
                                        for number in 0..<model.list.count {
                                            QuestionArray.append(model.list[number].question)
                                            ThemeArray1.append(model.list[number].name)
                                            ThemeArray2.append(model.list[number].notes)
                                            ThemeidArray.append(model.list[number].id)
                                            
                                            
                                            
                                            
                                        }
                                        if AlreadyThemeArray[selection-1].count>0 {
                                            for number in 0..<AlreadyThemeArray[selection-1].count{
                                                if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                                    ThemeArray1.remove(at: index)
                                                    ThemeArray2.remove(at: index)
                                                    QuestionArray.remove(at: index)
                                                    ThemeidArray.remove(at:index)
                                                }
                                            }
                                        }
                                        Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                        print(QuestionArray)
                                        print(ThemeidArray)
                                        path.append("FourthView")
                                    }
                                },access: {noInternetaccess = true})
                            
                        }
                        Button("前の画面に戻る"){
                            
                            animate = false
                            path.append("ChooseTopicView")
                            Loading = false
                            
                        }}
                }
            
            if Loading == false{
                VStack(spacing:0){
                    
                    
                    Divider()
                    TopTabView(list:list,selectedTab: $selectedTab).padding(.bottom,5)
                    TabView(selection:$selectedTab,
                            content: {
                        ZStack {
                            // 背景色指定
                            
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
//                                Text("ージャンルを選択ー").fontWeight(.regular).font(.system(size:25)).padding(.top,CGFloat(height)/10)
                                
                                Picker(selection:$selection,label:Text("ジャンル選択1")){
                                    Text("-ジャンルを選択-").tag(0).font(.system(size:20))
                                    Text("恋愛").tag(1).font(.system(size:30)).fontWeight(.bold)
                                    Text("スポーツ").tag(2).font(.system(size:30)).fontWeight(.bold)
                                    Text("仕事").tag(3).font(.system(size:30)).fontWeight(.bold)
                                    Text("芸能").tag(4).font(.system(size:30)).fontWeight(.bold)
                                    Text("学校").tag(5).font(.system(size:30)).fontWeight(.bold)
                                    Text("美容").tag(6).font(.system(size:30)).fontWeight(.bold)
                                    Text("生活").tag(7).font(.system(size:30)).fontWeight(.bold)
                                    Text("その他").tag(8).font(.system(size:30)).fontWeight(.bold)
                                    
                                }.pickerStyle((WheelPickerStyle())).frame(width:CGFloat(width)/1.3).clipped().padding(.top,CGFloat(height)/10)
            
                                // 「これで決定」ボタンの定義
                                Button(action:{
                                    Loading = true
                                    if Alreadyselection.firstIndex(of: selection) == nil{
                                        print("初")
                                        Alreadyselection.append(selection)
                                        model.getData(Theme:CategoryArray[selection],completion: {
                                            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                                QuestionArray=[]
                                                ThemeArray1=[]
                                                ThemeArray2=[]
                                                ThemeidArray = []
                                                for number in 0..<model.list.count {
                                                    QuestionArray.append(model.list[number].question)
                                                    ThemeArray1.append(model.list[number].name)
                                                    ThemeArray2.append(model.list[number].notes)
                                                    ThemeidArray.append(model.list[number].id)
                                                    
                                                    
                                                    
                                                    
                                                }
                                                for number in 0..<model.list.count {
                                                    AlreadyThemeArray1[selection-1].append(model.list[number].name)
                                                    AlreadyThemeArray2[selection-1].append(model.list[number].notes)
                                                    AlreadyQuestionArray[selection-1].append(model.list[number].question)
                                                    AlreadyThemeidArray[selection-1].append(model.list[number].id)
                                                    AllThemeArray1[selection-1].append(model.list[number].name)
                                                    AllThemeArray2[selection-1].append(model.list[number].notes)
                                                    AllQuestionArray[selection-1].append(model.list[number].question)
                                                    AllThemeidArray[selection-1].append(model.list[number].id)
                                                    
                                                }
                                                //↓このif文機能してないから消す(ジャンル選択で毎回読み取りする場合は消さない）
//                                                if AlreadyThemeArray[selection-1].count>0 {
//                                                    for number in 0..<AlreadyThemeArray[selection-1].count{
//                                                        if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
//                                                            ThemeArray1.remove(at: index)
//                                                            ThemeArray2.remove(at: index)
//                                                            QuestionArray.remove(at: index)
//                                                            ThemeidArray.remove(at:index)
//                                                            
//                                                        }
//                                                    }
//                                                }
                                                Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                                print(QuestionArray)
                                                print(ThemeidArray)
                                                path.append("FourthView")
                                            }
                                        },access: {noInternetaccess = true})
                                        
                                    }
                                    
                                    else {
                                        print("二回目")
                                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                                            ThemeidArray = AlreadyThemeidArray[selection-1]
                                            for number in 0..<AlreadyThemeArray[selection-1].count{
                                                if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                                    RemovenumberArray.append(index)
                                                    
                                                }
                                            }
                                            RemovenumberArray.sort{$0>$1}
                                            print(RemovenumberArray)
                                            
                                            for number in 0..<RemovenumberArray.count{
                                                
                                                    AlreadyThemeArray1[selection-1].remove(at: RemovenumberArray[number])
                                                    AlreadyThemeArray2[selection-1].remove(at: RemovenumberArray[number])
                                                    AlreadyQuestionArray[selection-1].remove(at: RemovenumberArray[number])
                                                    AlreadyThemeidArray[selection-1].remove(at: RemovenumberArray[number])
                                                    
                                                
                                                
                                            }
                                            
                                            ThemeArray1 = AlreadyThemeArray1[selection-1]
                                            ThemeArray2 = AlreadyThemeArray2[selection-1]
                                            QuestionArray = AlreadyQuestionArray[selection-1]
                                            ThemeidArray = AlreadyThemeidArray[selection-1]
                                            print(QuestionArray)
                                            print(ThemeidArray)
                                            Themenumber = Int.random(in: 0...ThemeArray1.count-1)
                                            path.append("FourthView")
                                        }
                                    }
                                    
                                    
                                }) {
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
                        ZStack {
                            // 背景色指定
                            
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
//                                Text("ージャンルを選択ー").fontWeight(.semibold).font(.system(size:25)).padding(.top,CGFloat(height)/7)
                                Picker(selection:$selection,label:Text("ジャンル選択1")){
                                    Text("-ジャンルを選択-").tag(0).font(.system(size:20))
                                    Text("恋愛").tag(1).font(.system(size:30)).fontWeight(.bold)
                                    Text("スポーツ").tag(2).font(.system(size:30)).fontWeight(.bold)
                                    Text("仕事").tag(3).font(.system(size:30)).fontWeight(.bold)
                                    Text("芸能").tag(4).font(.system(size:30)).fontWeight(.bold)
                                    Text("学校").tag(5).font(.system(size:30)).fontWeight(.bold)
                                    Text("美容").tag(6).font(.system(size:30)).fontWeight(.bold)
                                    Text("生活").tag(7).font(.system(size:30)).fontWeight(.bold)
                                    Text("その他").tag(8).font(.system(size:30)).fontWeight(.bold)
                                    
                                }.pickerStyle((WheelPickerStyle())).frame(width:CGFloat(width)/1.3,height: CGFloat(height)/10).clipped().padding(.top,CGFloat(height)/7)
                                
                                HStack(alignment: .center){
                                    Text("Q.")
                                        .font(.system(size:CGFloat(width)/10))
                                        .shadow(color:.primary.opacity(0.3),radius: 3,x:4,y:4)
                                    TextEditor(text:$Question)
                                        .frame(width:CGFloat(width)/1.4,height: CGFloat(height)/15)
                                        .focused($isKeybordon)
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing)
                                        .shadow(color:.primary.opacity(0.3),radius: 3,x:4,y:4)
                                    
                                    
                                }
                                // お題入力用のテキストボックス追加
                                HStack(alignment: .top,spacing:25) {
                                    ZStack{
                                        
                                        
                                        TextEditor(text:$Theme1)
                                            .frame(width:CGFloat(width)/2.5,height: CGFloat(height)/3)
                                            .padding(.leading, 30.0)
                                            .focused($isKeybordon)
                                            .multilineTextAlignment(.leading)
                                            .shadow(color:.primary.opacity(0.1),radius: 3,x:4,y:4)
                                        
                                        
                                    }
                                       
                                    
                                    TextEditor(text:$Theme2)
                                        .frame(width:CGFloat(width)/2.5,height: CGFloat(height)/3)
                                        .padding(.trailing, 30.0)
                                        .focused($isKeybordon)
                                        .multilineTextAlignment(.leading)
                                        .shadow(color:.primary.opacity(0.1),radius: 3,x:4,y:4)
                                }
                                
                                Button(action:{
                                    
                                    
                                    Decide = true
                                }
                                ) {
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
                                .alert("作成したお題をオンラインで\n公開しますか？",isPresented: $Decide){
                                    Button("はい"){
                                        share = true
                                        path.append("OfflineView")
                                            model.addData(Theme:CategoryArray[selection],question: Question,name: Theme1, notes: Theme2)
                                    }
                                    Button("いいえ"){
                                        share = true
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
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("出題方法を選択")
                .edgesIgnoringSafeArea(.bottom )
            }
        }.navigationBarBackButtonHidden(true)
            .toolbar{
                if Loading == false{
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(
                            action:{
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
                        anonymousWhich: .constant(true),
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
                        ThemeUploadWhich:.constant(false),
                        Question: .constant("質問"),
                        Theme1:.constant("お題1"),
                        Theme2:.constant("お題2"),
                        AlreadyThemeArray1: .constant([["お題1全部"]]),
                        AlreadyThemeArray2: .constant([["お題全部"]]),
                        AlreadyQuestionArray: .constant([["a"]]),
                        AlreadyThemeidArray: .constant([["ID"]]),
                        AllThemeArray1: .constant([["お題1全部"]]),
                        AllThemeArray2: .constant([["お題全部"]]),
                        AllQuestionArray: .constant([["質問全部"]]),
                        AllThemeidArray: .constant([["ID全部"]]),
                        Alreadyselection: .constant([0])
                        )
    }
}
