import SwiftUI

struct WeatherIndicatorSwiftUIView: View {
    var weatherCondition: String
    var body: some View {
        HStack {
            Image(systemName: weatherCondition)
                .resizable()
        }
        .padding()
    }
}
