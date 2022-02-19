//
//  likeCounter.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 23.10.2021.
//

import UIKit

protocol LikeCounterProtocol: AnyObject {
    func likeCounterIncrement(counter: Int)
    func likeCounterDecrement(counter: Int)
}

@IBDesignable class likeCounter: UIView {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCounterLable: UILabel!
    
    var likeEnable = false
    @IBInspectable var counter: Int = 0

    weak var delegate: LikeCounterProtocol?
    
    private var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "likeCounter", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    private func setup() {
        view = loadFromNib()
        guard let view = view else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    @IBAction func pressHeartButton(_ sender: Any) {
        
            guard let button = sender as? UIButton else {return}
            if likeEnable {
                button.setImage(UIImage(systemName: "heart"), for: .normal)
                counter -= 1
                likeCounterLable.text = String(counter)
                delegate?.likeCounterDecrement(counter: counter)
                animatedHeart()
            } else {
                button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                counter += 1
                likeCounterLable.text = String(counter)
                delegate?.likeCounterIncrement(counter: counter)
                animatedHeart()
            }
            likeEnable = !likeEnable
        }
        
    func animatedHeart() {
        self.likeButton.transform = CGAffineTransform(translationX: 1,
                                                     y: -view!.bounds.height/10)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                           self.likeButton.transform = .identity
                       },
                       completion: nil)
    }

}
