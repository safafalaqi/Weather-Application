//
//  ViewController.swift
//  Weather Application
//
//  Created by Safa Falaqi on 22/12/2021.
//

import UIKit
import SwiftVideoBackground

class ViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var dailyCollection: UICollectionView!
    var dailyWeather: [ListDaily]? = []
    var currentWeather: CurrentWeather?
    
    var cityName = "new york"
    
    @IBOutlet weak var cityButton: UIButton!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var cloudCoverLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadDailyData()
        loadCurrentData()
        
        // Do any additional setup after loading the view.
        dailyCollection.dataSource = self
        dailyCollection.delegate = self
       // loadDailyData()
        
        try? VideoBackground.shared.play(view: view, videoName: "video", videoType: "mp4")
    
    }
    //to change city name
    @IBAction func cityNamePressed(_ sender: UIButton) {
        

        let alert = UIAlertController(title: "Change Location", message: "Enter a City Name or Zipcode", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "City Name or Zipcode"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.cityName = textField.text!
               print("Text field: \(self.cityName )")
            
            self.loadDailyData()
            self.loadCurrentData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadDailyData(){
       
        // create a "data task" to make the request and run completion handler
        DailyForecastModel.getDailyForcast(city: cityName, completionHandler: {
                    // see: Swift closure expression syntax
                    data, response, error in
                    // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
                    // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
                    do {
                      
                        //optional unwraping
                        guard let myData = data else {return}
                        
                        let decoder = JSONDecoder()
                        
                        let jesonResult = try decoder.decode(DailyForcast.self, from: myData)
                        var i = 0
                     
                        while i < jesonResult.list.count{
                            
                            self.dailyWeather?.append(jesonResult.list[i])
                            
                            i = i+8
                          
                        }
                        
                        DispatchQueue.main.async {
                         self.dailyCollection.reloadData()
                            
                        }
                        
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                        self.wrongInputAlert()
                        }
                       
                    }
                })
        
        
    }
    func loadCurrentData(){
      
        
         // create a "data task" to make the request and run completion handler
        CurrentWeatherModel.getCurrentWeather(city: cityName, completionHandler: {
                     // see: Swift closure expression syntax
                     data, response, error in
                     // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
                     // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
                     do {
                        
                         //optional unwraping
                         guard let myData = data else {return}
                         
                         let decoder = JSONDecoder()
                         
                         let jesonResult = try decoder.decode(CurrentWeather.self, from: myData)
                         self.currentWeather = jesonResult

                         //print(jesonResult)
                         DispatchQueue.main.async {
                             self.cityButton.setTitle(self.currentWeather?.name, for: .normal)
                             self.cityButton.titleLabel?.font = .systemFont(ofSize: 30)
                             
                           var d = Date(timeIntervalSince1970:  TimeInterval(self.currentWeather!.dt))
                             
                             self.currentDateLabel.text = "Updated at:  \(d.dateAndTimetoString())"
                             
                             self.descriptionLabel.text =  self.currentWeather?.weather[0].weatherDescription
                         
                             self.currentTempLabel.text = "\((self.currentWeather?.main.temp)!) C°"
                             self.lowTempLabel.text = "Low: \((self.currentWeather?.main.tempMin)!) C°"
                             self.highTemp.text = "High: \((self.currentWeather?.main.tempMax)!) C°"
                             
                             d = Date(timeIntervalSince1970:  TimeInterval(self.currentWeather!.sys.sunrise))
                             self.sunriseLabel.text = d.dayTime()
                             d = Date(timeIntervalSince1970:  TimeInterval(self.currentWeather!.sys.sunset))
                             self.sunsetLabel.text = d.dayTime()
                             
                             self.windLabel.text =   "\(self.currentWeather!.wind.speed) MPH"
                             
                             self.cloudCoverLabel.text = "\(self.currentWeather!.clouds.all)%"
                             
                             self.humidityLabel.text = "\(self.currentWeather!.main.humidity)%"
                             
                             self.pressureLabel.text = "\(self.currentWeather!.main.pressure)%"

                             
                             self.weatherImage.downloaded(from: "http://openweathermap.org/img/wn/\(self.currentWeather!.weather[0].icon)@2x.png")
                            
                         }
                         
                     } catch {
                         print(error)
                        
                     }
                 })
        
    }
    func wrongInputAlert(){
        
        let alert = UIAlertController(title: "Wrong Input!!", message: "Enter a correct city name or zipcode", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "City Name or Zipcode"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.cityName = textField.text!
               print("Text field: \(self.cityName )")
            
            self.loadDailyData()
            self.loadCurrentData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }


}


extension ViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return dailyWeather?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let dailyCell = dailyCollection.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyCollectionViewCell
        
        if indexPath.row % 2 == 1{
            dailyCell.backgroundColor = UIColor(red: 110/255.0, green: 200.0/255.0, blue: 246.0/255.0, alpha: 1)
        }else{
            dailyCell.backgroundColor = UIColor(red: 72.0/255.0, green: 164.0/255.0, blue: 200.0/255.0, alpha: 1)
        }
        let d = Date(timeIntervalSince1970:  TimeInterval(dailyWeather![indexPath.row].dt))
        
        dailyCell.dayLabel.text = d.dayName()
        dailyCell.weatherDescriptionLabel.text = String(dailyWeather![indexPath.row].weather[0].weatherDescription)
        dailyCell.tempMinLabel.text = String(dailyWeather![indexPath.row].main.tempMin)
        dailyCell.tempMaxLabel.text = String(dailyWeather![indexPath.row].main.tempMax)
        dailyCell.image.downloaded(from:"http://openweathermap.org/img/wn/\(dailyWeather![indexPath.row].weather[0].icon)@2x.png")

            return dailyCell
    }
    
   
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dayTime(format: String = "HH:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dayName(format: String = "EEEE") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
