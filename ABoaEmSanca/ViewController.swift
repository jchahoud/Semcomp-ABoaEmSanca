//
//  ViewController.swift
//  ABoaEmSanca
//
//  Created by Juliana Chahoud on 8/19/14.
//  Copyright (c) 2014 jchahoud. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
                            
    @IBOutlet weak var partyLabel: UILabel!
    
    @IBOutlet weak var partyImage: UIImageView!

    let APITOKEN = "cfi0vtturic/pv85hiwuM9EfYecr5sg4087z5kK7GNl3az6ELQQn6bEazFrV52m/w6LtUmaZct2pq7/fKc9voA=="

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNextParty(sender: UIButton) {
    
        //formatar a data de hoje e
       
        // var today = self.currentDate()
        var today = "2014-08-21"
        
        //URL da API usada
        let apiUrl = NSURL (string: "http://sanca.goldarkapi.com/event?date=$gt:\(today)&order_by=date:asc")
        
        //Criacao de uma variavel do tipo request a partir da URL da API
        var request = NSMutableURLRequest (URL: apiUrl)
        
        //Metodo HTTP usado - GET eh usado para listar eventos
        request.HTTPMethod = "GET"
        
        //chave de acesso a API
        request.addValue(APITOKEN, forHTTPHeaderField: "X-Api-Token")
        
        //variavel para guardar erro
        var err: NSErrorPointer = nil
        
        //variavel que guarda a resposta do request
        var response: NSURLResponse?
        
        //envio do request de modo síncrono (para testes)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: err)
        
        //transformar JSON em Dicionario
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: err) as NSDictionary
        
        //dentro do JSON vem um array com as informacoes das festas
        if let partiesArray:NSArray = jsonResult["data"] as? NSArray
        {
            //criar um Dicionario com a primeira posicao do array
            if let var party:NSDictionary = partiesArray[0] as? NSDictionary
            {
                //pega as informacoes "name" e depois "date" no dicionario
                let partyName = party["name"] as? NSString
                let partyDate = party["date"] as? NSString
                
                //formatar o texto do label com as informacoes da festa
                self.partyLabel.text = partyName! + ": " + self.formattedDate(partyDate!)
                
                //Ler a URL de onde esta a imagem
                let urlString: NSString = party["bigimageurl"] as NSString
                let imgURL: NSURL = NSURL(string: urlString)
                
                //pegar a imagem efetivamente em formato NSData
                let imgData: NSData = NSData(contentsOfURL: imgURL)
                
                //atualiza a imagem da ImageView
                self.partyImage.image = UIImage(data: imgData)
            }
        }
    }
    
    func currentDate() ->String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.stringFromDate(date)
    }
    
    func formattedDate(date:NSString) ->String{
        let month = date.substringWithRange(NSMakeRange(5, 2))
        let day = date.substringWithRange(NSMakeRange(8, 2))
        let hour = date.substringWithRange(NSMakeRange(11, 2))
        let min = date.substringWithRange(NSMakeRange(14, 2))
        return day + "/" + month + " " + hour + ":" + min
    }
}





