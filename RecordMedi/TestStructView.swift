//
//  TestStructView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/11.
//

import SwiftUI
import UIKit


class User{
    var name:String
    var count:Int
    init(name:String,count:Int){
        self.name=name
        self.count=count
    }
}
struct TestStructView: View {
    @State private var user=User(name:"showna",count:1)
    
    var body: some View {
        HStack{
            Text("\(user.name),\(user.count)")
            TextField("name", text: $user.name)
            Button("add count",action:{
//                user.count = 1
                dump(user)
                print(unsafeBitCast($user, to: Int.self))
            })
        }
    }
}

struct TestStructView_Previews: PreviewProvider {
    static var previews: some View {
        TestStructView()
    }
}
