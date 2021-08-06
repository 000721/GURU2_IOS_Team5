//
//  GalleryShow.swift
//  SchedulerSWU
//
//  Created by 이지연 on 2021/08/01.
//

import UIKit

class GalleryShow:UIViewController,UIScrollViewDelegate{
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var images = [#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "Image2"),#imageLiteral(resourceName: "Image3")]
    var images2 = [#imageLiteral(resourceName: "Image4"),#imageLiteral(resourceName: "Image6"),#imageLiteral(resourceName: "Image5")]

    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
            super.viewDidLoad()

            scrollView.delegate = self
            addContentScrollView()
            //setPageControl()
        
        self.navigationController?.navigationBar.tintColor = .systemPink
        self.navigationController?.navigationBar.topItem?.title = ""
        
        }
    
    private func addContentScrollView() {
            
            for i in 0..<images.count {
                let imageView = UIImageView()
                let xPos = self.view.frame.width * CGFloat(i)
                imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                imageView.image = images[i]
                scrollView.addSubview(imageView)
                scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            }
            
        }
    
        

}
