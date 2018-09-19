//
//  Constants.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit

protocol ReuseIdentifier : class {
    
}
extension ReuseIdentifier where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView : class{
    
}
extension NibLoadableView where Self : UIView {
    static var nibName : String {
        return String(describing: self)
    }
    
}
// UITableView Register
extension UITableView{
    func register<T>(cell : T.Type) where T : ReuseIdentifier,T : UITableViewCell , T : NibLoadableView {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T : UITableViewCell, T : ReuseIdentifier {
        guard  let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(type(of: self)) Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
}

//// UIStoryboard Register
//extension UIStoryboard {
//    func instantiateVC<T: UIViewController>() -> T? {
//        if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
//            return instantiateViewController(withIdentifier: name) as? T
//        }
//        return nil
//    }
//}
// Alert for generic
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


extension UIView{
    func showBlurLoader(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        
        self.addSubview(blurEffectView)
    }
    
    func removeBluerLoader(){
        self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
            $0.removeFromSuperview()
        }
    }
}
