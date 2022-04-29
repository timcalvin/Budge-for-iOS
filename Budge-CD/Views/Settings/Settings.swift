//
//  Settings.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import SwiftUI
import StoreKit

struct Settings: View {
    
    @ObservedObject var vm: ViewModel
    @Environment(\.openURL) var openURL
    
    @FocusState var taxRateIsFocused: Bool
    
    let email = SupportEmail(toAddress: "calvinkayphoto@gmail.com", subject: "Budge Bug Report", messageHeader: "Please describe your issue below:")
    
    @State private var taxRate = UserDefaults.standard.double(forKey: "TaxRate")
    
    //    init(vm: ViewModel) {
    //        let navBarAppearance = UINavigationBar.appearance()
    //        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.budgeDarkGray)]
    //        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(.budgeDarkGray)]
    //        navBarAppearance.tintColor = UIColor(.budgeDarkGray)
    //
    //        self.vm = vm
    //    }
    
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
                                .foregroundColor(.budgeDarkGray)
                        }
                    }
                    
                    // YNAB
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
                            .padding(.leading, 30)
                        
                        HStack {
                            Image(systemName: "percent")
                                .resizable()
                                .foregroundColor(.budgeLightGray)
                                .frame(width: 20, height: 20)
                                .cornerRadius(3)
                            TextField("Enter tax rate", value: $taxRate, format: .number)
                                .focused($taxRateIsFocused)
                                .keyboardType(.decimalPad)
                                .onChange(of: taxRate) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "TaxRate")
                                    //                                    HapticManager.instance.impact(style: .light)
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        HStack {
                                            Spacer()
                                            Button {
                                                taxRateIsFocused = false
                                            } label: {
                                                Text("Done")
                                                    .foregroundColor(.budgeBlue)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    // iCloud Storage
                } header: {
                    Text("User")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.budgeDarkGray)
                }
                
                Section {
                    Button {
                        DispatchQueue.main.async {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.budgeLightGray)
                            Text("Write a review")
                                .foregroundColor(.budgeDarkGray)
                        }
                    }
                    
                    Button {
                        email.send(openURL: openURL)
                    } label: {
                        HStack {
                            Image(systemName: "ladybug.fill")
                                .foregroundColor(.budgeLightGray)
                            Text("Report a bug")
                                .foregroundColor(.budgeDarkGray)
                        }
                    }
                    
                } header: {
                    Text("User")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.budgeDarkGray)
                } footer: {
                    Text("App version \(Constants.versionNumber)")
                }
                
            }
//            .colorMultiply(.budgeBlue)
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)   
        }
        .onAppear {
            
        }
        //        .preferredColorScheme(.light)
    }
}
