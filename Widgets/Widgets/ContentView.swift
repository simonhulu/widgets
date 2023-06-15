//
//  ContentView.swift
//  Widgets
//
//  Created by zhang shijie on 2023/6/14.
//

import SwiftUI


struct ContentView: View {
  let model:HomeViewModel = HomeViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding().onAppear(perform: model.requestLocation)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
