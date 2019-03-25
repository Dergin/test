//
//  ViewController.swift
//  prueba
//
//  Created by Adrian on 21/10/18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var uiImage: UIImageView!
    let url:NSURL = NSURL(string: "https://www.lavanguardia.com/r/GODO/LV/p5/WebSite/2018/11/12/Recortada/img_oribalta_20181112-195823_imagenes_lv_otras_fuentes_pokemon_detective_pikachu-kbNE-U452886719981O5F-992x558@LaVanguardia-Web.jpg")!
    let url2:NSURL = NSURL(string: "https://vignette.wikia.nocookie.net/es.pokemon/images/b/be/Charmander_%28anime_SO%29.png/revision/latest?cb=20120906002506")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = try? Data(contentsOf: url as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        uiImage.image = UIImage(data: data!)
        sleep(4)

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        sleep(4)
        let data = try? Data(contentsOf: url2 as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        uiImage.image = UIImage(data: data!)
    }
    
}

