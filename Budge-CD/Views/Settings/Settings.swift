//
//  Settings.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import SwiftUI

struct Settings: View {
    
    @ObservedObject var vm: ViewModel
    
    @State private var taxRate = 0.0
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    NavigationLink {
                        AppIcon()
                    } label: {
                        HStack {
                            Image("budgeIconMain")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .cornerRadius(3)
                            Text("App Icon")
                        }
                    }

                } header: {
                    Text("App")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.budgeDarkGray)
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Tax Rate")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.budgeDarkGray)
                        
                        TextField("Price", value: $taxRate, format: .percent)
                            .keyboardType(.decimalPad)
                            .onChange(of: taxRate) { newValue in
                                HapticManager.instance.impact(style: .light)
                            }
                    }
                } header: {
                    Text("User")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.budgeDarkGray)
                }
                
                Section {
                    Text("Write a review")
                    Text("Report a bug")
                } header: {
                    Text("User")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.budgeDarkGray)
                }

                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {

        }
    }
}
