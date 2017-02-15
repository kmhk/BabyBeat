//
//  CC_Recordings.swift
//  Baby Beat
//
//  Created by OSX on 18/03/16.
//  Copyright © 2016 Appsmaven. All rights reserved.
//

import UIKit

class CC_Recordings: UITableViewCell {

    @IBOutlet weak var mViewPlay: UIView!
    @IBOutlet weak var mViewDetails: UIView!
    @IBOutlet weak var mViewGraph: UIView!
    @IBOutlet weak var mViewOverGraph: UIView!

    @IBOutlet weak var mLblName: UILabel!
    @IBOutlet weak var mBtnPlay: UIButton!
    @IBOutlet weak var mLblWeekNumber: UILabel!
    @IBOutlet weak var mLblTimeCount: UILabel!
    @IBOutlet weak var mBtnShare: UIButton!
    @IBOutlet var mCnstPLayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mViewPlotVisualisation: EZAudioPlot!

    @IBOutlet var mImgPlayBack: UIImageView!
    @IBOutlet var mImgOverlay: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
