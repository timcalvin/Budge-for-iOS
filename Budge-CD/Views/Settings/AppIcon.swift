//
//  AppIcon.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/27/22.
//

import SwiftUI

struct AppIcon: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        List {
            
            Section {
                
                HStack {
                    Button {
                        UIApplication.shared.setAlternateIconName(nil)
                    } label: {
                        Image("budgeIconMain")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Original")
                            .bold()
                        Text("Beautiful blue")
                            .font(.caption)
                    }
                    .foregroundColor(.budgeDarkGray)
                }
                
                HStack {
                    Button {
                        UIApplication.shared.setAlternateIconName("GradientIcon")
                    } label: {
                        Image("budgeIconGradient")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Gradient")
                            .bold()
                        Text("Light and fun")
                            .font(.caption)
                    }
                    .foregroundColor(.budgeDarkGray)
                }
                
                HStack {
                    Button {
                        UIApplication.shared.setAlternateIconName("LightIcon")
                    } label: {
                        Image("budgeIconLight")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Light")
                            .bold()
                        Text("Old school")
                            .font(.caption)
                    }
                    .foregroundColor(.budgeDarkGray)
                }
                
                HStack {
                    Button {
                        UIApplication.shared.setAlternateIconName("DarkIcon")
                    } label: {
                        Image("budgeIconDark")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text("Dark Mode")
                            .bold()
                        Text("Easy on the eyes")
                            .font(.caption)
                    }
                    .foregroundColor(.budgeDarkGray)
                }
                
            }
 
        }
        .listStyle(.insetGrouped)
        .navigationTitle("App Icon")
    }
}
