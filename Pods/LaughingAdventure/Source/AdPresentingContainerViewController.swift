/*
* Copyright 2015 Coodly LLC
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

public class AdPresentingContainerViewController: UIViewController {
    @IBOutlet var contentPresentingView: UIView?
    @IBOutlet var adContainerView: UIView!
    @IBOutlet var adContainerHeightConstraint: NSLayoutConstraint!
    public var presented: UIViewController?
    
    var banner: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        adContainerHeightConstraint.constant = 0
        
        guard let show = presented else {
            return
        }
        
        guard let container = contentPresentingView else {
            return
        }
        
        addChildViewController(show)

        show.view.frame = container.bounds
        show.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        container.addSubview(show.view)
    }
    
    public override func viewDidAppear(animated: Bool) {
        if let _ = banner {
            return
        }
        
        banner = createBanner()
        banner.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleBottomMargin]
        adContainerView.addSubview(banner)
    }
    
    public func showBanner(banner: UIView) {
        banner.center = CGPointMake(CGRectGetWidth(adContainerView.frame) / 2, CGRectGetHeight(adContainerView.frame) / 2)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.adContainerHeightConstraint.constant = CGRectGetHeight(banner.frame)
            self.view.layoutIfNeeded()
        })
    }
    
    public func hideBanner(banner: UIView) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.adContainerHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    public func createBanner() -> UIView {
        fatalError("Override createBanner")
    }
}