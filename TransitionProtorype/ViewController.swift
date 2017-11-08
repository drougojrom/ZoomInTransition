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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let cell = tableView.cellForRow(at: selectedIndex) as! TableViewCell

        cell.avatarImage.isHidden = false
        cell.avatarImage.alpha = 1
        cell.setSelected(false, animated: false)
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
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            cell.avatarImage.alpha = 0
        }) { (_) in
            cell.avatarImage.isHidden = true
        }
        selectedFrame = cell.avatarImage.frame
        selectedFrame.origin.y = CGFloat(40 + (indexPath.row * 120))
        selectedIndex = indexPath
        performSegue(withIdentifier: "toDetail", sender: "123")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! DetailViewController
            vc.transitioningDelegate = self
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedFrame
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
