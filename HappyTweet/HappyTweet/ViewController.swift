//
//  ViewController.swift
//  HappyTweet
//
//  Created by Jose Manuel Garcia de la O on 6/5/19.
//  Copyright © 2019 Jose Manuel Garcia de la O. All rights reserved.
//

import UIKit
import Foundation




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///Traer Objetos
    @IBOutlet weak var tvBusqueda: UITextField!
    @IBOutlet weak var ivPefil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var tweets:[String] = [];
    
    
    //configurar tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.myTextView.text = tweets[indexPath.row];
        ViewController.revisarTweet(tweet : tweets[indexPath.row], completion: { result in
           // print(result);
            
            if(result < -0.25){
                print("entraste a triste")
                cell.imagenEmoji.image = UIImage(named: "triste.png");
            }else if(result > 0.25 ){
                print("entraste a feliz")
                cell.imagenEmoji.image = UIImage(named: "feliz.png");
                
            }else{
                print("entraste a neutro")
                cell.imagenEmoji.image = UIImage(named: "neutro.png");
            }
        });
        
        
        
        return cell;
    }
    
    
    var googleAPIKey = "AIzaSyAJM8mP94TuIvzFZ7uRBJgStt_6Xt5iU58"
    
    
    
    ///Solicita la informacion del sentimiento por tweet
    class func revisarTweet(tweet: String,  completion: @escaping ((_ result:Float) -> Void)){
        //print("----------------------------------------");
       // print(tweet);
        //print("----------------------------------------");
        
       
        
        // prepare json data
        let json:[String:Any] = [
            "document": [
                "type": "PLAIN_TEXT",
                "content": tweet],
            "encodingType": "UTF8"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://language.googleapis.com/v1/documents:analyzeSentiment?key=AIzaSyAJM8mP94TuIvzFZ7uRBJgStt_6Xt5iU58")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        
        
        // insert json data to the request
        request.httpBody = jsonData
        // stateCode: 123
        
        var result:Float  = 0.0;
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let datos = data else {return;}
            
            
            
            do{
                let dataSentimiento = try JSONDecoder().decode(SantimientoModelo.self, from: datos)
                result = dataSentimiento.documentSentiment!.score;
        
                completion(result);
                

               
            }catch{
               // debugPrint(error)
            }
            
        }.resume()
        
        
    }
    
    
   
    
    
    
    
    
    @IBAction func btnBuscar(_ sender: UIButton) {
        
        if(tvBusqueda.text != ""){
            let busqueda = tvBusqueda.text?.replacingOccurrences(of: " ", with: "");
            traerTweets(usuario:busqueda!);
            
            var count = 1;
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of
                
                if(count == 1){
                    self.myTableView.reloadData();
                    count = 2;
                }
                
                }
            
            
            
            
        }
    }
    
    ////Crear funcion que traiga los tweets
    func traerTweets(usuario:String){
        let url = URL(string: "https://twitter.com/" + usuario);
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if(error != nil){
                
                DispatchQueue.main.async {
                    if let mensajeError = error?.localizedDescription{
                        self.lblNombre.text = mensajeError;
                    }else{
                        self.lblNombre.text = "Ha habido un error, Intenta de nuevo ";
                    }
                }
          
            }else{
                let webContent:String = String(data:data!, encoding: String.Encoding.utf8)!;
                
                if (webContent.contains("<title>") && webContent.contains("data-resolved-url-large=\"")){
                    ///Traer el nombre del usuario
                    var array:[String] = webContent.components(separatedBy: "<title>");
                    array = array[1].components(separatedBy: " |");
                    let nombreUsuario = array[0];
                    array.removeAll();
                    
                    
                    
                    ///Traer foto de perfil
                    array = webContent.components(separatedBy: "data-resolved-url-large=\"");
                    array = array[1].components(separatedBy: "\"");
                    let fotoPerfil = array[0];
                    
                    
                    ///Traer Tweets
                    array = webContent.components(separatedBy: "data-aria-label-part=\"0\">");
                    array.remove(at: 0);
                    
                    for i in 0 ... array.count-1{
                        let newTweet  = array[i].components(separatedBy: "<");
                        array[i] = newTweet[0];
                        
                    }
                    
                    self.tweets = array;
                    
                    DispatchQueue.main.async {
                       
                            self.lblNombre.text = nombreUsuario;
                            self.actualizarImagen(url: fotoPerfil);
                        
                        
                    }
                    

                    
                }
                else{
                    DispatchQueue.main.async {
                        self.lblNombre.text = "El nombre de Usuario No Existe";
                       
                    }
                }
                
                
            }
        }.resume();
        
     
    }
    
    ////Funcion para mostrar la foto de perfil
    func actualizarImagen(url:String){
        let url = URL(string: url);
        
        let task = URLSession.shared.dataTask(with: url!) { (data, respuesta, error) in
            DispatchQueue.main.async {
                self.ivPefil.image = UIImage(data:data!);
            }
        }
        task.resume();
       
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
      // let resultado = revisarTweet(tweet : "I feel very happy for everything that I have achieved, and I hope that tomorrow I get what I want");
       // let resultados = revisarTweet(tweet : "I feel very upset about your way of behaving");

        // Do any additional setup after loading the view.
      
    }


}

