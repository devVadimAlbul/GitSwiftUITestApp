import SwiftUI

struct RepositoryRowView: View {
  
  var repository: GitRepository
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        Image(systemName: "doc.text.fill")
        Text(repository.fullName).font(.headline).lineLimit(2)
        Spacer()
      }
      Text(repository.descriptionField ?? "").font(.body).lineLimit(nil)
      
      HStack {
        Image(systemName: "circle.fill").foregroundColor(Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))).font(.headline)
        Text(repository.language ?? "").font(.subheadline)
        Spacer()
        Image(systemName: "star.fill")
        Text("\(repository.stargazersCount)")
      }
    }
  }
}


