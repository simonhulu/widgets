//
//  LargeWidget.swift
//  Widgets
//
//  Created by zhang shijie on 2023/6/15.
//

import Foundation
import WidgetKit
import SwiftUI
import Intents
import Alamofire


struct LargeProvider: IntentTimelineProvider {
    private var location:TLocationManager = TLocationManager()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(),wel: nil,city: "Beijing")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration,wel: nil,city: "Beijing")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
      location.didComplete = false
      location.requestLocation { cllLoc in

        if let loc = cllLoc{
          let geocoder = CLGeocoder()
          geocoder.reverseGeocodeLocation(loc) { (placemarks, error) in
              let locationString: String
              if let placemark = placemarks?.first {
                  locationString = placemark.locality ?? "Beijing"
              } else {
                  locationString = "Beijing"
              }
              updateData(location: loc) { wel in
                let timeline = Timeline(entries: [SimpleEntry(date: Date(), configuration: configuration, wel: wel,city: locationString)], policy: .atEnd)
                completion(timeline)
              }
          }
        }else{
          let timeline = Timeline(entries: [SimpleEntry(date: Date(), configuration: configuration, wel: nil,city: "Beijing")], policy: .atEnd)
          completion(timeline)
        }
      }

    }

  func updateData(location:CLLocation,completion:@escaping (Welcome?)->Void){
    let geocoder = CLGeocoder()

     let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        if latitude != 0, longitude != 0{
          let locationString = "\(longitude),\(latitude)"
          let url:String = "https://devapi.qweather.com/v7/weather/7d?location=\(locationString)&key=3575188f3b1e4551bd80bc8cba3865e5"
          AF.request(url).response{response in
            let res = response.result
            switch res{
            case .success(let data):
              let s = data
              if let res = data{
                do {
                  let decodedData = try JSONDecoder().decode(Welcome.self,
                                                             from: res)
                  completion(decodedData)
                } catch  _{

                  let daily:Daily = Daily(fxDate: "2023-06-15", sunrise: "04:44", sunset: "19:47", moonrise: "02:31", moonset: "17:10", moonPhase: "残月", moonPhaseIcon: "807", tempMax: "35", tempMin: "23", iconDay: "100", textDay: "晴", iconNight: "150", textNight: "晴", wind360Day: "180", windDirDay: "南风", windScaleDay: "1-2", windSpeedDay: "3", wind360Night: "180", windDirNight: "南风", windScaleNight: "1-2", windSpeedNight: "3", humidity: "42", precip: "0.0", pressure: "1000", vis: "25", cloud: "25", uvIndex: "11")
                  let refer:Refer = Refer(sources: ["CC BY-SA 4.0"], license:  [
                    "QWeather",
                    "NMC",
                    "ECMWF"
                ])
                  let wel:Welcome = Welcome(code: "200", updateTime: "2023-06-15T05:35+08:00", fxLink: "https://www.qweather.com/weather/beijing-101010100.html", daily: [daily], refer: refer)
                  completion(wel)
                }
              }
            case .failure( _):
              let daily:Daily = Daily(fxDate: "2023-06-15", sunrise: "04:44", sunset: "19:47", moonrise: "02:31", moonset: "17:10", moonPhase: "残月", moonPhaseIcon: "807", tempMax: "35", tempMin: "23", iconDay: "100", textDay: "晴", iconNight: "150", textNight: "晴", wind360Day: "180", windDirDay: "南风", windScaleDay: "1-2", windSpeedDay: "3", wind360Night: "180", windDirNight: "南风", windScaleNight: "1-2", windSpeedNight: "3", humidity: "42", precip: "0.0", pressure: "1000", vis: "25", cloud: "25", uvIndex: "11")
              let refer:Refer = Refer(sources: ["CC BY-SA 4.0"], license:  [
                "QWeather",
                "NMC",
                "ECMWF"
            ])
              let wel:Welcome = Welcome(code: "200", updateTime: "2023-06-15T05:35+08:00", fxLink: "https://www.qweather.com/weather/beijing-101010100.html", daily: [daily], refer: refer)
              completion(wel)
            }
          }
        }
  }
//  }
//  func updateData() {
//      // 发起网络请求获取数据
//      URLSession.shared.dataTask(with: '') { data, response, error in
//          // 处理网络请求的结果
//          if let error = error {
//              // 处理请求错误
//              print("网络请求错误：\(error)")
//              return
//          }
//
//          guard let data = data else {
//              // 处理无效的数据
//              print("无效的数据")
//              return
//          }
//
//          // 解析和处理数据
//          do {
//              let decodedData = try JSONDecoder().decode(YourDataModel.self, from: data)
//
//              // 在主线程更新数据
//              DispatchQueue.main.async {
//                  // 将解析的数据更新到你的小组件的数据模型中
//                  yourWidgetData = decodedData
//
//                  // 刷新小组件的显示
//                  WidgetCenter.shared.reloadAllTimelines()
//              }
//          } catch {
//              // 处理数据解析错误
//              print("数据解析错误：\(error)")
//          }
//      }.resume()
//  }

}

struct LargeWidgetEntryView : View {
    var entry: LargeProvider.Entry
    var body: some View {
      let skyBlue = Color.init(hex: 0xFFFFFF)
       ZStack {
           skyBlue
         VStack(alignment: .leading){
           Text(entry.city).foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 15)).fontWeight(.medium).padding(.leading,3)
             HStack{
               Text(entry.wel?.daily.first?.tempMax ?? "").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 40)).fontWeight(.thin)
               Spacer()
               Text(entry.wel?.daily.first?.windDirDay ?? "").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 14)).fontWeight(.light)
               Text("\(entry.wel?.daily.first?.windScaleDay ?? "")级").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 14)).fontWeight(.light)
               VStack{
                 Image("36").resizable().scaledToFit().frame(width: 30,height: 30)
                 Text(entry.wel?.daily.first?.textDay ?? "").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 12)).fontWeight(.light)
               }
             }

            HStack{
              ForEach(entry.wel?.daily ?? [],id: \.self){daily in
                 VStack{
                   Text(daily.tempMax ?? "").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 8)).fontWeight(.medium)
                   Image("36").frame(width: 28 ,height: 28).padding(.top,-7)
                   Text(dateFormatter(dateString: daily.fxDate) ?? "").foregroundColor(Color.init(hex: 0x5686DF)).font(.system(size: 10))
                 }.frame(minWidth: 0, maxWidth: .infinity)
                 }
             }

         }.padding()
           }
       }
}

extension LargeWidgetEntryView{
  func dateFormatter(dateString:String?)->String{
    if let dateString = dateString{
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let date = dateFormatter.date(from: dateString)
      if let date = date{
        let desDateFormatter = DateFormatter()
        desDateFormatter.dateFormat = "EEEE"
        var day = desDateFormatter.string(from: date)
        switch day{
          case "Monday":
          day = "Mon"
        case "Tuesday":
          day = "Tue"
        case "Wednesday":
          day = "Wed"
        case "Thursday":
          day = "Thu"
        case "Friday":
          day = "Fri"
        case "Saturday":
          day = "Sta"
        case "Sunday":
          day = "Sun"
        default:
          day = "Sun"
        }
        return day
      }
    }
    return ""
  }
}

struct LargeWidget: Widget {
    let kind: String = "largetWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LargeProvider()) { entry in
          LargeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([ .systemMedium])
    }
}

struct LargeWidget_Previews: PreviewProvider {
    static var previews: some View {
      LargeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),wel: nil,city: "Beijing"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


