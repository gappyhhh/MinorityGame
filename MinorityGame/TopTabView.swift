//
//  TopTabView.swift
//  MinorityGame
//
//  Created by kazuhiro hirata on 2023/09/27.
//

import SwiftUI
import UIKit

struct TopTabView: View {
   
    let list:[String]
    @Binding var selectedTab:Int
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        
        HStack(spacing:0){
            ForEach(0..<list.count,id: \.self){row in
                Button(action:{
                    withAnimation{
                        selectedTab = row
                    }
                },label:{
                    VStack(spacing:0){
                        HStack{
                            VStack{
                                if row == 0{
                                    Image("Online")
                                        .resizable(capInsets: EdgeInsets())
                                        .scaledToFit()
                                        .frame(width:CGFloat(width)/1.5)
                                        .padding(.top,5)
                                }
                                if row == 1{
                                    Image("InputMyself")
                                        .resizable(capInsets: EdgeInsets())
                                        .scaledToFit()
                                        .frame(width:CGFloat(width)/1.5)
                                        .padding(.top,5)
                                }
                                Text(list[row])
                                    .font(Font.system(size:CGFloat(width)/25,weight: .semibold))
                                    .foregroundColor(Color.primary)
                            }
                        }
                        .frame(
                            width:(UIScreen.main.bounds.width/CGFloat(list.count)),
                            height: 100
                        )
                        Rectangle()
                            .fill(selectedTab==row ?Color.red:Color.clear)
                            .frame(height:3)
                    }
                    .fixedSize()
                })
            }
        }
        .frame(height:100)
        .background(Color.white)
        .compositingGroup()
        .shadow(color:.primary.opacity(0.3),radius: 3,x:4,y:4)
    }
}

struct TopTabView_Previews: PreviewProvider {
    static var previews: some View {
        TopTabView(list:["ボタン1"], selectedTab: .constant(0))
    }
}
