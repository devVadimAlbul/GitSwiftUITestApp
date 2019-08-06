//
//  LoginView.swift
//  GitSwiftUITestApp
//
//  Created by Vadim Albul on 8/1/19.
//  Copyright © 2019 Dev. All rights reserved.
//

import SwiftUI

struct LoginView: View {
  
  @ObservedObject var viewModel: LoginViewModel
  @EnvironmentObject var accountHelper: AccountHelper
  
    var body: some View {
      VStack {
        InputFextField(label: "Username:", placeholder: "Enter username", textBinding: $viewModel.username, isSecure: false)
        
        InputFextField(label: "Password:", placeholder: "Enter password", textBinding: $viewModel.password, isSecure: true)
          .padding(.bottom, 30)
        
        Button(action: {
          self.viewModel.apply(.onSubmit)
        }) {
          HStack {
            Spacer()
            Text("Login").font(.title).foregroundColor(.white)
            Spacer()
          }
        }
        .disabled(!self.viewModel.output.isValid)
        .padding()
        .background(viewModel.output.isValid ? Color.red : Color.gray)
      }
      .alert(isPresented: $viewModel.isErrorShown) { () -> Alert in
        Alert(title: Text("Error"), message: Text(viewModel.output.errorMessage))
      }
    }
}
