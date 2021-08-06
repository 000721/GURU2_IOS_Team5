//
//  GalleryBg.swift
//  SchedulerSWU
//
//  Created by swuad_28 on 2021/07/29.
//

import UIKit

class GalleryBg:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bgView.setGradient(color1: #colorLiteral(red: 0.8470588326454163, green: 0.7098039388656616, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 0.5490196347236633, blue: 0.5490196347236633, alpha: 1), color3: #colorLiteral(red: 1, green: 1, blue: 0.7803921699523926, alpha: 1))
    }
    //배경색
    @IBOutlet weak var bgView: UIView!
    
}

extension UIView{
    func setGradient(color1:UIColor,color2:UIColor, color3:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor, color3.cgColor]
        gradient.locations = [0.0 , 0.484375, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: -3.0616171314629196e-17)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.9999999999999999)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }

}

