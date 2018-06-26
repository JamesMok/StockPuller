//
//  ViewController.swift
//  StockPuller
//
//  Created by James Mok on 2018-06-26.
//  Copyright © 2018 James Mok. All rights reserved.
//

import UIKit

struct Quote: Decodable {
    let symbol: String
    let delayedPrice: Decimal
    let high: Decimal
    let low: Decimal
    let delayedSize: Int
    let delayedPriceTime: Decimal
    let processedTime: Decimal
    
    /*init(json: [String: Any]) {
        symbol = json["symbol"] as? String ?? "Unknown"
        delayedPrice = json["delayedPrice"] as? Decimal ?? 00.00
        high = json["high"] as? Decimal ?? 00.00
        low = json["low"] as? Decimal ?? 00.00
        delayedSize = json["delayedSize"] as? Int ?? 200
        delayedPriceTime = json["delayedPriceTime"] as? Decimal ?? 00.00
        processedTime = json["processedTime"] as? Decimal ?? 00.00

    } */
}

class ViewController: UIViewController {
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var stockNameLbl: UILabel!
    @IBOutlet weak var stockPageBackBtn: UIButton!
    @IBOutlet weak var stockInfoLbl: UILabel!
    @IBOutlet weak var stockTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var intervalSegCtl: UISegmentedControl!
    @IBOutlet weak var StockInfoPage: UIView!
    @IBOutlet weak var backgroundBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func findBtnPressed(_ sender: Any) {
        
        if(stockTxt.text?.isEmpty)!{
            errorLbl.text = "No Symbol Found!"
        }
        else{
        
        let jsonUrlString = "https://api.iextrading.com/1.0/stock/" +  stockTxt.text! + "/delayed-quote"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err!.localizedDescription)
            }
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                print(quote.delayedPrice)
                DispatchQueue.main.async {
                    self.stockInfoLbl.text = "$" + String(describing: quote.delayedPrice)
                    self.stockNameLbl.text = quote.symbol
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        
        StockInfoPage.isHidden = false
        backgroundBG.isHidden = false
        stockNameLbl.isHidden = false
        stockInfoLbl.isHidden = false
        stockPageBackBtn.isHidden = false
        stockPageBackBtn.isEnabled = true
        findBtn.isHidden = true
        stockTxt.isHidden = true
        intervalSegCtl.isHidden = true
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        StockInfoPage.isHidden = true
        backgroundBG.isHidden = true
        stockNameLbl.text = ""
        stockNameLbl.isHidden = true
        stockInfoLbl.isHidden = true
        stockInfoLbl.text = ""
        stockPageBackBtn.isHidden = true
        stockPageBackBtn.isEnabled = false
        findBtn.isHidden = false
        stockTxt.isHidden = false
        intervalSegCtl.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

