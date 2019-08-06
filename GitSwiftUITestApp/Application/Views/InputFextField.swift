import SwiftUI

struct InputFextField: View {
  var label: String
  var placeholder: String
  @Binding var textBinding: String
  var isSecure: Bool
  
  var textField: some View {
    VStack {
      if isSecure {
        SecureField(placeholder, text: $textBinding)
      } else {
        TextField(placeholder, text: $textBinding)
      }
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing:8) {
      Text(label)
        .padding(.horizontal, 12)
        .font(.headline)
        .foregroundColor(.black)
      
      textField
        .padding()
        .font(.body)
        .background(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
        .foregroundColor(.white)
    }
  }
}

#if DEBUG
struct InputFextField_Previews: PreviewProvider {
  static var previews: some View {
    InputFextField(label: "Test",
                   placeholder: "Test",
                   textBinding: .constant(""), isSecure: false)
  }
}
#endif
