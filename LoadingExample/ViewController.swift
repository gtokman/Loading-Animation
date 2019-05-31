//
//  ViewController.swift
//  LoadingExample
//
//  Created by Gary Tokman on 5/28/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit
import SkeletonView

struct Item {
    let title: String
    let description: String
    let image: UIImage?
}

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!

    // MARK: Props
    
    var items: [Item] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = SkeletonGradient(baseColor: .alizarin)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        getSomething { [weak self] items in
            self?.items = items
            self?.view.hideSkeleton()
        }
    }
    
    // MARK: Functions
    
    func getSomething(completion: @escaping ([Item]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
            let renderer = UIGraphicsImageRenderer(bounds: rect)
            var items = [Item]()
            _ = renderer.image(actions: { (ctx) in
                for i in 0..<15 {
                    [UIColor.red, UIColor.blue, UIColor.yellow]
                        .randomElement()?
                        .setFill()
                    ctx.fill(rect)
                    items.append(Item(
                        title: "Title \(i)",
                        description: "Description \(i)",
                        image: ctx.currentImage)
                    )
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completion(items)
            }
        }
    }
}

// MARK: Date source

extension ViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Cell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.customTitle?.text = item.title
        cell.customDescription?.text = item.description
        cell.customImageView?.image = item.image
        return cell
    }
}

