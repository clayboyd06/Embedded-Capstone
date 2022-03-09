//  NOT USED ANYMORE--------------------
//  ClimateDropdown.swift
//  Landmarks
//
//  Created by Oscar Zeng on 1/30/22.
//  Reference: https://emmanuelkehinde.io/creating-a-simple-and-reusable-dropdown-selector-in-swiftui/
//  NOT USED ANYMORE--------------------

import SwiftUI

struct ClimateDropdown: View {
    // show or hide the dropdown when the ClimateDropdown is tapped
    @State private var shouldShowDropdown = false
    
    // keep track of user selection and replace the placeholder
    @State private var selectedOption: ClimateOption? = nil
    
    // the greyed out text to display before the user selects an option
    var placeholder: String
    
    // a list of the ClimateOption
    var options: [ClimateOption]
    
    // a closure called when user makes selection
    var onOptionSelected: ((_ option: ClimateOption) -> Void)?
    
    private let buttonHeight: CGFloat = 45

    var body: some View {
        Button(action: {
            self.shouldShowDropdown.toggle()
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.system(size: 14))
                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)

                Spacer()

                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(Color.black)
            }
        }
        .padding(.horizontal)
        .cornerRadius(17)
        .frame(width: .infinity, height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .stroke(Color.gray, lineWidth: 1)
        )
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 10)
                    
                    // "onOptionSelected" was "onSelect" on the webstie
                    Dropdown(options: self.options, onOptionSelected: { option in
                        shouldShowDropdown = false
                        selectedOption = option
                        self.onOptionSelected?(option)
                    })
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: 17).fill(Color.white)
        )
    }
}

struct ClimateDropdown_Previews: PreviewProvider {
    static var uniqueKey: String {
            UUID().uuidString
        }

    static let options: [ClimateOption] = [
        ClimateOption(key: uniqueKey, value: "Sunday"),
        ClimateOption(key: uniqueKey, value: "Monday"),
        ClimateOption(key: uniqueKey, value: "Tuesday"),
        ClimateOption(key: uniqueKey, value: "Wednesday"),
        ClimateOption(key: uniqueKey, value: "Thursday"),
        ClimateOption(key: uniqueKey, value: "Friday"),
        ClimateOption(key: uniqueKey, value: "Saturday")
    ]


    static var previews: some View {
        Group {
            ClimateDropdown(
                placeholder: "Day of the week",
                options: options,
                onOptionSelected: { option in
                    print(option)
            })
            .padding(.horizontal)
        }
    }
}

struct ClimateOption: Hashable {
    let key: String
    let value: String
    
    public static func == (lhs: ClimateOption, rhs: ClimateOption) -> Bool {
        return lhs.key == rhs.key
    }
}

// Contains a stack of DropdownRow (Single option row item) by iterating dropdown options

struct Dropdown: View {
    // list of dropdown options
    var options: [ClimateOption]
    
    // a closure to be triggered when an option is selected
    var onOptionSelected: ((_ option: ClimateOption) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(17)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

// A text button that calls onOptionSelected on tap
struct DropdownRow: View {
    var option: ClimateOption
    var onOptionSelected: ((_ option: ClimateOption) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
