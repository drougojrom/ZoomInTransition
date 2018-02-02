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

    var selectedIndex: IndexPath!
    var selectedFrame: CGRect!
    
    var final: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let cell = tableView.cellForRow(at: selectedIndex) as! TableViewCell

        cell.avatarImage.isHidden = false
        cell.avatarImage.alpha = 1
        cell.setSelected(false, animated: false)
        tableView.alpha = 1
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        selectedFrame = cell.avatarImage.bounds
        selectedFrame.origin = view.convert(CGPoint.zero, from: cell.avatarImage)
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
        let view = UIView(frame: CGRect(x: 110, y: 30, width: 155, height: 155))
        view.backgroundColor = UIColor.blue
        return Animator(duration: 1.5, presenting: true, originFrame: selectedFrame, finalView: view)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let view = SomeView.fromNib()
        view.frame = CGRect(x: 110, y: 30, width: view.bounds.width, height: view.bounds.height)
        return Animator(duration: 1.5, presenting: false, originFrame: selectedFrame, finalView: view)
    }
}
