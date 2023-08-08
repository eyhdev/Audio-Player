//
//  HomeViewModel.swift
//  Audio_Player
//
//  Created by ayhan on 24.03.2022.
//

import SwiftUI
import AVKit

let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Audio", ofType: "mp3")!)

class HomeViewModel : ObservableObject{

  @Published var player = try! AVAudioPlayer(contentsOf: url)
  @Published var  isPlaying = false
  @Published var album = Album()
  @Published var angle : Double = 0


  func updateTimer(){
    let currentTime = player.currentTime
    let total = player.duration
    let progress = currentTime / total

    withAnimation(Animation.linear(duration: 0.1)){
      self.angle = Double(progress) * 288
    }
    isPlaying = player.isPlaying
  }

  func fetchAlbum(){

      let assest = AVAsset(url: player.url!)

      assest.metadata.forEach { (meta) in

      switch(meta.commonKey?.rawValue){

      case "title": album.title = meta.value as? String ?? ""
      case "artist": album.artist = meta.value as? String ?? ""
      case "type": album.type = meta.value as? String ?? ""
      case "artwork": if meta.value != nil{album.artwork = UIImage(data: meta.value as! Data)!}
      default: ()

      }
    }

  }

  func onChanged(value: DragGesture.Value){
    let vector = CGVector(dx: value.location.x, dy: value.location.y)
    let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
    let temAngle = radians * 180 / .pi
    let angle = temAngle < 0 ? 360 + temAngle : temAngle

    if angle <= 288 {

      let progress = angle / 288
      let time = TimeInterval(progress) * player.duration
      player.currentTime = time
      player.play()
      withAnimation(Animation.linear(duration: 0.1)){self.angle = Double(angle)}
    }
    
  }

  func play(){
    
    if player.isPlaying{player.pause()}
    else{player.pause()}
    isPlaying = player.isPlaying
    
  }

  func getCurrentTime(value: TimeInterval)-> String{

    return "\(Int(value / 60)): \(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"

  }


}
