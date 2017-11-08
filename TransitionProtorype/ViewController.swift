//
//  ViewController.swift
//  TransitionProtorype
//
//  Created by Roman Ustiantcev on 06/11/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let transition = Animator()
    var selectedIndex: IndexPath!
    var selectedFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailVC.transitioningDelegate = self
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            cell.avatarImage.alpha = 0
        }) { (_) in
            cell.avatarImage.isHidden = true
        }
        self.selectedFrame = cell.frame
        selectedIndex = indexPath
        present(detailVC, animated: true, completion: {
            cell.avatarImage.isHidden = false
            cell.avatarImage.alpha = 1
            cell.setSelected(false, animated: false)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let someView = SomeView.fromNib()
        someView.frame = CGRect(x: 16, y: 41, width: 78, height: 78)
        transition.originFrame = someView.frame
        
        transition.presenting = true
        //selectedImage!.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
