//
//  ExpandableButtonItem.swift
//  Landmarks
//
//  Created by stlp on 1/31/22.
//
import SwiftUI

struct ExpandableButtonItem_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewExpand()
    }
}

// Represents the content for each of our buttons
struct ExpandableButtonItem: Identifiable {
  let id = UUID()
  let label: String
  private(set) var action: (() -> Void)? = nil
}

struct ExpandableButtonPanel: View {
    
  // Gradient colors
  var color1 = Color(0xB0CAFA)
  var color2 = Color(0x699BF7)

  // the button that is always visible
  let primaryItem: ExpandableButtonItem
    
  // each of the expanded buttons to be shown or hidden
  let secondaryItems: [ExpandableButtonItem]

  private let noop: () -> Void = {}
  private let size: CGFloat = 80
//  private var cornerRadius: CGFloat {
//    get { size / 2 }
//  }
  private let shadowColor = Color.black.opacity(0.4)
  private let shadowPosition: (x: CGFloat, y: CGFloat) = (x: 2, y: 2)
  private let shadowRadius: CGFloat = 3

  // REMOVED PRIVATE TO TEST OUTER FUNCTION CALLING - Now Binding to share
@Binding var isExpanded: Bool // keep track of current state, will toggle
  var body: some View {
    VStack {
      ForEach(secondaryItems) { item in
        Button(item.label, action: item.action ?? self.noop)
          .frame(
            width: self.isExpanded ? self.size : 0,
            height: self.isExpanded ? self.size : 0)
          .foregroundColor(.white)
          .cornerRadius(17)
      }

      Button(primaryItem.label, action: {
          // Commented out for individaul button expanding vs all expand in content view
//        withAnimation {
//          self.isExpanded.toggle()
//        }
        self.primaryItem.action?()
      })
    .frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 15,
        alignment: .center
    )
    .foregroundColor(.white)
    .background(
        LinearGradient(
            colors: [color1, color2], startPoint: .leading,
            endPoint: .trailing
        )
    )
    .cornerRadius(17)
//      .frame(width: size, height: size)
    }
//    .background(Color(UIColor.systemPurple))
    .background(
        LinearGradient(
        colors: [color1, color2], startPoint: .leading,
        endPoint: .trailing
    ))
    .cornerRadius(17)
    .shadow(
      color: shadowColor,
      radius: shadowRadius,
      x: shadowPosition.x,
      y: shadowPosition.y
    )
  }
}

// Testing view
struct ContentViewExpand: View {

  @State private var showAlert: Bool = true
  @State private var alertLabel: String = ""

  var body: some View {
    // NavigationView {
      ZStack {
        // List
//        List(1...20, id: \.self) { i in
//          Text("Item #\(i)")
//            .padding()
//        }
        // Floating Button Panel
        VStack {
          Spacer()
          HStack {
            Spacer()
            ExpandableButtonPanel(
              primaryItem: ExpandableButtonItem(label: "Humidity"),
              secondaryItems: [
                ExpandableButtonItem(label: "ooga") {
                  self.alertLabel = "ooga"
                  self.showAlert.toggle()
                },
                ExpandableButtonItem(label: "booga") {
                  self.alertLabel = "booga"
                  self.showAlert.toggle()
                }
              ],
              isExpanded: self.$showAlert
            )
            .padding()
          }
        }
      }
      .alert(isPresented: $showAlert) {
        return Alert(title: Text("You selected \(self.alertLabel)"))
      }
      .navigationBarTitle("Numbers")
    // }
  }
}
