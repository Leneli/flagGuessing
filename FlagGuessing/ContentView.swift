//
//  ContentView.swift
//  FlagGuessing
//
//  Created by  Elena Kuklina on 16.04.2021.
//

import SwiftUI

struct HSpacer: View {
  var body: some View {
    HStack {
      Spacer()
    }
  }
}

struct SettingsButton: View {
  @State private var showAlert = false
  
  var level: Int
  var getComplexity: ((Int) -> Void)
  
  var message: String {
    switch level {
      case 2:
        return "Ваш текущий уровень сложности: Легко"
      case 3:
        return "Ваш текущий уровень сложности: Нормально"
      case 6:
        return "Ваш текущий уровень сложности: Сложно"
      default:
        return "Выберите сложность:"
    }
  }
  
  var body: some View {
    Button(action: { self.showAlert = true }) {
      Image(systemName: "gearshape")
    }.actionSheet(isPresented: $showAlert, content: {
      ActionSheet(
        title: Text("Сложность"),
        message: Text(message),
        buttons: [
          .default(Text("Легко"), action: { getComplexity(2) }),
          .default(Text("Нормально"), action: { getComplexity(3) }),
          .default(Text("Сложно"), action: { getComplexity(6) }),
          .cancel(Text("Отменить"))
        ]
      )
    })
  }
}

struct Title: View {
  var title: String
  
  var body: some View {
    Text("\(title)")
      .font(.title)
      .padding()
  }
}

struct Flag: View {
  @State private var showAlert = false
  @State private var alertTitile = ""
  @State private var alertMessage = ""

  var flag: String
  var trueIndex: Int
  var thisIndex: Int
  var getResult: ((Int) -> Void)
  var alertAction: (() -> Void)
  
  var body: some View {
    Button(action: {
      if trueIndex == thisIndex {
        getResult(1)
        alertTitile = "Верно!"
        alertMessage = "Молодец, угадал :)"
      } else {
        getResult(-1)
        alertTitile = "Ошибка!"
        alertMessage = "Учи географию, лузер!"
      }
      
      self.showAlert = true
    }) {
      Image(flag)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
        .padding(.horizontal, 70)
        .padding(.vertical, 10)
    }
    .alert(isPresented: $showAlert) {
      Alert(
        title: Text(alertTitile),
        message: Text(alertMessage),
        dismissButton: .default(Text("Продолжить"), action: alertAction)
      )
    }
  }
}

struct TotalScore: View {
  var number: Int
  
  var scoreTextColor: Color {
    if number < 0 { return .red }
    if number > 0 { return .green }
    return .black
  }

  var body: some View {
    HStack {
      Text("Ваш счет:")
      Text("\(number)")
        .fontWeight(.bold)
        .foregroundColor(scoreTextColor)
    }
    .font(.title2)
    .padding()
  }
}



struct ContentView: View {
  @State private var countries = [
    (name: "Argentina", flag: "argentina-flag-xs"),
    (name: "USA", flag: "united-states-of-america-flag-xs"),
    (name: "Bangladesh", flag: "bangladesh-flag-xs"),
    (name: "Brazil", flag: "brazil-flag-xs"),
    (name: "Canada", flag: "canada-flag-xs"),
    (name: "Germany", flag: "germany-flag-xs"),
    (name: "Greece", flag: "greece-flag-xs"),
    (name: "Russia", flag: "russia-flag-xs"),
    (name: "Sweden", flag: "sweden-flag-xs"),
    (name: "United Kingdom", flag: "united-kingdom-flag-xs")
  ].shuffled()
  @State private var score = 0
  @State private var showResultAlert = false
  @State private var flagsCounter = 3
  @State private var answerIndex = Int.random(in: 0..<3)
  
  func changeFlagsCounter(_ num: Int) {
    self.flagsCounter = num
    refresh()
  }
  
  func changeScore(_ num: Int) {
    score += num
  }
  
  func refresh() {
    countries.shuffle()
    answerIndex = Int.random(in: 0..<flagsCounter)
  
  }
  

  var body: some View {
    NavigationView {
      VStack {
        HSpacer()
        
        Title(title: countries[answerIndex].name)
      
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
          HSpacer()
          Spacer()
          
          ForEach(0..<flagsCounter, id: \.self) { index in
            Flag(
              flag: countries[index].flag,
              trueIndex: answerIndex,
              thisIndex: index,
              getResult: changeScore,
              alertAction: refresh
            )
          }

          Spacer()
        }
        
        TotalScore(number: score)
      }
      .navigationTitle("Угадай флаг страны")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
        trailing: SettingsButton(level: flagsCounter, getComplexity: changeFlagsCounter)
      )
      .background(Color.init(#colorLiteral(red: 0.9685428739, green: 0.9686816335, blue: 0.9685124755, alpha: 1)))
      .edgesIgnoringSafeArea(.bottom)
    }
  }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
