//
//  Home.swift
//  Audio_Player
//
//  Created by ayhan on 24.03.2022.
//

import SwiftUI

struct Home: View {
  @StateObject var homeData = HomeViewModel()
  @State var timer = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
  @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    var body: some View {
      VStack{
          Spacer(minLength: 0)
        ZStack{
          Image(uiImage: homeData.album.artwork)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(Circle())

          ZStack{

            Circle()
              .trim(from: 0, to: 0.8)
              .stroke(Color.black.opacity(0.06), lineWidth: 4)
              .frame(width: width + 45, height: width + 45)


            Circle()
              .trim(from: 0, to: CGFloat(homeData.angle) / 360)
              .stroke(Color.black, lineWidth: 4)
              .frame(width: width + 45, height: width + 45)

            Circle()
              .fill(Color.black)
              .frame(width: 25, height: 25)
              .offset(x: (width + 45) / 2)
              .rotationEffect(.init(degrees: homeData.angle))
              .gesture(DragGesture().onChanged(homeData.onChanged(value:)))
          }
          .rotationEffect(.init(degrees: 126))
          Text(homeData.getCurrentTime(value: homeData.player.currentTime))
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (width + 60) / 2)

          Text(homeData.getCurrentTime(value: homeData.player.duration))
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (width + 60) / 2)

        }

        Text(homeData.album.title)
          .font(.title2)
          .fontWeight(.heavy)
          .foregroundColor(.black)
          .padding(.top,25)
          .padding(.horizontal)
          .lineLimit(1)

        Text(homeData.album.artist)
          .foregroundColor(.gray)
          .padding(.top,5)
          
          HStack(spacing: 55){

          Button(action: {}){

            Image(systemName: "backward.fill")
              .font(.title)
              .foregroundColor(.gray)
          }
          Button(action: homeData.play){
            Image(systemName: homeData.isPlaying ? "pause.fill" : "play.fill")
              .font(.title)
              .foregroundColor(.white)
              .padding()
              .background(Color.black)
              .clipShape(Circle())
          }
          Button(action: {}){

            Image(systemName: "forward.fill")
              .font(.title)
              .foregroundColor(.gray)
          }
        }
        .padding(.top, 25)


        Spacer(minLength: 0)
      }
      .onAppear(perform: homeData.fetchAlbum)
      .onReceive(timer) {(_) in
        homeData.updateTimer()

      }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
