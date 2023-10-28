//
//  ResultView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/05.
//

import SwiftUI
import Firebase

struct ResultView: View {
    @State private var selectedTab:Int = 0
    @ObservedObject var model = ViewModel()
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
    @Binding var Theme1CounterArray:[Int]
    @Binding var Theme2CounterArray:[Int]
    @Binding var AllTheme1CounterArray:[[Int]]
    @Binding var AllTheme2CounterArray:[[Int]]
    
    @State var isPresented: Bool = false
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        let list:[String] = ["結果","全国"]
        
        VStack(spacing:0){
            
            //タブ表示をTopTabViewから持ってくる
            Divider()
            TopTabResultView(list:list,selectedTab: $selectedTab).padding(.bottom,5)
            TabView(selection:$selectedTab,
                    content: {
                ZStack {
                    // 背景指定
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
                    
                    VStack(alignment: .center,spacing:10) {
                        
//                        Image("Result")
//                            .resizable(capInsets: EdgeInsets())
//                            .scaledToFit()
//                            .frame(width:CGFloat(width)/1.5)
                        
                        //                HStack(alignment: .bottom,spacing:20){
                        //                    Text("名前を表示する：")
                        //                    Toggle("",isOn:$anonymous).labelsHidden()
                        //                        .onAppear {
                        //                            //初期値を代入
                        //                            anonymous = false
                        //                        }
                        //                }
                        
                        HStack{
                            Text("Q.")
                                .font(.system(size:CGFloat(width)/15))
                            Text(QuestionArray[Themenumber])
                                .font(.system(size:CGFloat(width)/18))
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }.padding(.top,CGFloat(height)/12.5)
                        Spacer()
                        HStack(alignment: .bottom,spacing:20){
                            VStack(spacing:0){
                                //                        Text(String(ResultCount1))
                                //                            .font(.system(size:CGFloat(height)/20))
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
                                            .background(ONlineResultShow_red ? .white:.red)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                    }
                                } else {
                                    Text(ThemeArray1[Themenumber])
                                        .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(ResultMemberArray1.count)/21)
                                        .foregroundColor(Color.black)
                                        .background(ONlineResultShow_red ? .white:.red)
                                        .font(.system(size:CGFloat(height)/45))
                                }
                            }
                            VStack(spacing:0){
                                //                        Text(String(ResultCount2))
                                //                            .font(.system(size:CGFloat(height)/20))
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
                                            .background(ONlineResultShow_white ? .white:.red)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                    }
                                } else {
                                    Text(ThemeArray2[Themenumber])
                                        .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(ResultMemberArray2.count)/21)
                                        .foregroundColor(Color.black)
                                        .background(ONlineResultShow_white ? .white:.red)
                                        .font(.system(size:CGFloat(height)/45))
                                }
                            }
                            
                        }
                        
                        //                Text("選んだ理由について話し合ってみよう！")
                        //                    .font(.system(size:CGFloat(width)/22))
                        
                        HStack(alignment: .bottom,spacing:20){
                            Text("名前を表示する：")
                                .padding(.bottom,CGFloat(height)/200)
                            Toggle("",isOn:$anonymous).labelsHidden()
                                .onAppear {
                                    //初期値を代入
                                    anonymous = false
                                }
                        }
                        HStack(alignment: .center,spacing:0){
                            // 「ジャンル選択へ」ボタンの定義
                            Button(action:{
                                model.updateData(Theme: CategoryArray[selection], id: ThemeidArray[Themenumber], ResultCounter1: ResultCount1+Theme1CounterArray[Themenumber], ResultCounter2: ResultCount2+Theme2CounterArray[Themenumber])
                                
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme1CounterArray[selection-1][index] = ResultCount1 + Theme1CounterArray[Themenumber]}
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme2CounterArray[selection-1][index] = ResultCount2 + Theme2CounterArray[Themenumber]}
                                //                        AllTheme1CounterArray[selection-1][Themenumber] = ResultCount1 + Theme1CounterArray[Themenumber]
                                //                        AllTheme2CounterArray[selection-1][Themenumber] = ResultCount2 + Theme2CounterArray[Themenumber]
                                
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
                            }
                            
                            // 「次の問題へ」ボタンの定義
                            Button(action:{
                                
                                model.updateData(Theme: CategoryArray[selection], id: ThemeidArray[Themenumber], ResultCounter1: ResultCount1+Theme1CounterArray[Themenumber], ResultCounter2: ResultCount2+Theme2CounterArray[Themenumber])
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme1CounterArray[selection-1][index] = ResultCount1 + Theme1CounterArray[Themenumber]}
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme2CounterArray[selection-1][index] = ResultCount2 + Theme2CounterArray[Themenumber]}
                                //                        Theme2CounterArray[Themenumber] = ResultCount2 + Theme2CounterArray[Themenumber]
                                ResultMemberArray1.removeAll()
                                ResultMemberArray2.removeAll()
                                AlreadyThemeArray[selection-1].append(ThemeidArray[Themenumber])
                                
                                for num in 0..<ReportidArray.count{
                                    AlreadyThemeArray[selection-1].append(ReportidArray[num])
                                    AllReportidArray.append(ReportidArray[num])
                                }
                                print(AlreadyThemeArray)
                                print(AllReportidArray)
                                
                                //↓昇順に並び替える必要あるかも
                                for number in 0..<AlreadyThemeArray[selection-1].count{
                                    if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                        ThemeArray1.remove(at: index)
                                        ThemeArray2.remove(at: index)
                                        QuestionArray.remove(at: index)
                                        ThemeidArray.remove(at:index)
                                        Theme1CounterArray.remove(at:index)
                                        Theme2CounterArray.remove(at:index)
                                    }
                                }
                                if QuestionArray.isEmpty == true{
                                    ThemeArray1 = AllThemeArray1[selection-1]
                                    ThemeArray2 = AllThemeArray2[selection-1]
                                    QuestionArray = AllQuestionArray[selection-1]
                                    ThemeidArray = AllThemeidArray[selection-1]
                                    Theme1CounterArray = AllTheme1CounterArray[selection-1]
                                    Theme2CounterArray = AllTheme2CounterArray[selection-1]
                                    
                                    for number in 0..<AllReportidArray.count{
                                        if let index = ThemeidArray.firstIndex(of: AllReportidArray[number]){
                                            ThemeArray1.remove(at: index)
                                            ThemeArray2.remove(at: index)
                                            QuestionArray.remove(at: index)
                                            ThemeidArray.remove(at:index)
                                            Theme1CounterArray.remove(at:index)
                                            Theme2CounterArray.remove(at:index)
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
                            }
                        }
                        .padding(.bottom,CGFloat(height)/10)
//                        Spacer()
                        
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
                    .tag(0)
                
                ZStack {
                    // 背景指定
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
                    
                    VStack(alignment: .center,spacing:10) {
                        
//                        Image("Result")
//                            .resizable(capInsets: EdgeInsets())
//                            .scaledToFit()
//                            .frame(width:CGFloat(width)/1.5)
                        
                        //                HStack(alignment: .bottom,spacing:20){
                        //                    Text("名前を表示する：")
                        //                    Toggle("",isOn:$anonymous).labelsHidden()
                        //                        .onAppear {
                        //                            //初期値を代入
                        //                            anonymous = false
                        //                        }
                        //                }
                        
                        HStack{
                            Text("Q.")
                                .font(.system(size:CGFloat(width)/15))
                            Text(QuestionArray[Themenumber])
                                .font(.system(size:CGFloat(width)/18))
                                .padding()
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                        .padding(.top,CGFloat(height)/12.5)
                        Spacer()
                        HStack(alignment: .bottom,spacing:20){
                            VStack(spacing:0){
                                //                        Text(String(ResultCount1))
                                //                            .font(.system(size:CGFloat(height)/20))
                                Text("\(Theme1CounterArray[Themenumber])")
                                    .padding(5)
                                    .font(.system(size:CGFloat(height)/35))
                                if anonymous == true {
                                    ForEach(0..<ResultMemberArray1.count, id:\.self ) {
                                        index in Text(ResultMemberArray1[index])
                                            .padding(4)
                                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/21)
                                            .font(.system(size:CGFloat(height)/35))
                                            .foregroundColor(Color.black)
                                            .background(ONlineResultShow_red ? .white:.red)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                    }
                                } else {
                                    Text(ThemeArray1[Themenumber])
                                        .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(Theme1CounterArray[Themenumber])/30)
                                        .foregroundColor(Color.black)
                                        .background(ONlineResultShow_red ? .white:.red)
                                        .font(.system(size:CGFloat(height)/45))
                                }
                            }
                            VStack(spacing:0){
                                //                        Text(String(ResultCount2))
                                //                            .font(.system(size:CGFloat(height)/20))
                                Text("\(Theme2CounterArray[Themenumber])")
                                    .padding(5)
                                    .font(.system(size:CGFloat(height)/35))
                                
                                if anonymous == true {
                                    ForEach(0..<ResultMemberArray2.count, id:\.self ) {
                                        index in Text(ResultMemberArray2[index])
                                            .padding(4)
                                            .frame(width:CGFloat(width)/2.4,height: CGFloat(height)/21)
                                            .font(.system(size:CGFloat(height)/35))
                                            .foregroundColor(Color.black)
                                            .background(ONlineResultShow_white ? .white:.red)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                    }
                                } else {
                                    Text(ThemeArray2[Themenumber])
                                        .frame(width:CGFloat(width)/2.4,height: CGFloat(height)*CGFloat(Theme2CounterArray[Themenumber])/30)
                                        .foregroundColor(Color.black)
                                        .background(ONlineResultShow_white ? .white:.red)
                                        .font(.system(size:CGFloat(height)/45))
                                }
                            }
                            
                        }
                        
                        //                Text("選んだ理由について話し合ってみよう！")
                        //                    .font(.system(size:CGFloat(width)/22))
                        
                        
                        HStack(alignment: .center,spacing:0){
                            // 「ジャンル選択へ」ボタンの定義
                            Button(action:{
                                model.updateData(Theme: CategoryArray[selection], id: ThemeidArray[Themenumber], ResultCounter1: ResultCount1+Theme1CounterArray[Themenumber], ResultCounter2: ResultCount2+Theme2CounterArray[Themenumber])
                                
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme1CounterArray[selection-1][index] = ResultCount1 + Theme1CounterArray[Themenumber]}
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme2CounterArray[selection-1][index] = ResultCount2 + Theme2CounterArray[Themenumber]}
                                //                        AllTheme1CounterArray[selection-1][Themenumber] = ResultCount1 + Theme1CounterArray[Themenumber]
                                //                        AllTheme2CounterArray[selection-1][Themenumber] = ResultCount2 + Theme2CounterArray[Themenumber]
                                
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
                            }
                            
                            // 「次の問題へ」ボタンの定義
                            Button(action:{
                                
                                model.updateData(Theme: CategoryArray[selection], id: ThemeidArray[Themenumber], ResultCounter1: ResultCount1+Theme1CounterArray[Themenumber], ResultCounter2: ResultCount2+Theme2CounterArray[Themenumber])
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme1CounterArray[selection-1][index] = ResultCount1 + Theme1CounterArray[Themenumber]}
                                if let index = AllThemeidArray[selection-1].firstIndex(of:ThemeidArray[Themenumber]){
                                    AllTheme2CounterArray[selection-1][index] = ResultCount2 + Theme2CounterArray[Themenumber]}
                                //                        Theme2CounterArray[Themenumber] = ResultCount2 + Theme2CounterArray[Themenumber]
                                ResultMemberArray1.removeAll()
                                ResultMemberArray2.removeAll()
                                AlreadyThemeArray[selection-1].append(ThemeidArray[Themenumber])
                                
                                for num in 0..<ReportidArray.count{
                                    AlreadyThemeArray[selection-1].append(ReportidArray[num])
                                    AllReportidArray.append(ReportidArray[num])
                                }
                                print(AlreadyThemeArray)
                                print(AllReportidArray)
                                
                                //↓昇順に並び替える必要あるかも
                                for number in 0..<AlreadyThemeArray[selection-1].count{
                                    if let index = ThemeidArray.firstIndex(of: AlreadyThemeArray[selection-1][number]){
                                        ThemeArray1.remove(at: index)
                                        ThemeArray2.remove(at: index)
                                        QuestionArray.remove(at: index)
                                        ThemeidArray.remove(at:index)
                                        Theme1CounterArray.remove(at:index)
                                        Theme2CounterArray.remove(at:index)
                                    }
                                }
                                if QuestionArray.isEmpty == true{
                                    ThemeArray1 = AllThemeArray1[selection-1]
                                    ThemeArray2 = AllThemeArray2[selection-1]
                                    QuestionArray = AllQuestionArray[selection-1]
                                    ThemeidArray = AllThemeidArray[selection-1]
                                    Theme1CounterArray = AllTheme1CounterArray[selection-1]
                                    Theme2CounterArray = AllTheme2CounterArray[selection-1]
                                    
                                    for number in 0..<AllReportidArray.count{
                                        if let index = ThemeidArray.firstIndex(of: AllReportidArray[number]){
                                            ThemeArray1.remove(at: index)
                                            ThemeArray2.remove(at: index)
                                            QuestionArray.remove(at: index)
                                            ThemeidArray.remove(at:index)
                                            Theme1CounterArray.remove(at:index)
                                            Theme2CounterArray.remove(at:index)
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
                            }
                        }
                        .padding(.bottom,CGFloat(height)/10)
//                        Spacer()
                        
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
                    .tag(1)
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
            }).tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("結果")
            .edgesIgnoringSafeArea(.bottom )
            .navigationBarBackButtonHidden(true)
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
                   AllReportidArray: .constant(["報告済みのお題全部"]),
                   Theme1CounterArray: .constant([0]),
                   Theme2CounterArray: .constant([0]),
                   AllTheme1CounterArray: .constant([[0]]),
                   AllTheme2CounterArray: .constant([[0]])
                   
        )
    }
}
