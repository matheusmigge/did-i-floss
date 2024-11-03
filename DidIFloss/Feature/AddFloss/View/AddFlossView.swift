//
//  AddFlossView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 31/01/24.
//

import SwiftUI


struct AddFlossView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedDate: Date = .now
    
    weak var delegate: AddFlossDelegate?
    
    var isSelectedDateValid: Bool {
        selectedDate < .now
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    
                    DatePicker("datePicker", selection: $selectedDate)
                        .datePickerStyle(.graphical)
                        .tint(.greenyBlue)
                    
                
                    
                    Button {
                        delegate?.addLogRecord(date: self.selectedDate)
                        
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor)
                            }
                            
                    }
                    .disabled(!isSelectedDateValid)
                    .opacity(isSelectedDateValid ? 1 : 0.75)
                    .overlay {
                        if !isSelectedDateValid {
                            Text("You may not add records in the future ")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .offset(y: -50)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            delegate?.addLogRecord(date: self.selectedDate)
                        } label: {
                            Text("Add")
                                .bold()
                        }
                        .disabled(!isSelectedDateValid)
                    }
                }
     
            }
        }
        .presentationDetents([.fraction(0.75), .large])
        .presentationCornerRadius(25)
        .presentationBackground(Material.regular)
    }

}

#Preview {
    AddFlossView()
}
