//
//  BombeEnigmaDetailsTableViewController.swift
//  iEnigma
//
//  Created by Leo Mehlig on 4/25/15.
//  Copyright (c) 2015 Leonard Mehlig. All rights reserved.
//

import UIKit

class BombeEnigmaDetailsTableViewController: UITableViewController {
    
    var decryptedText: String?
    var enigma: Enigma?
    
    @IBOutlet weak var decryptedTextLabel: UILabel! {
        didSet {
            decryptedTextLabel?.text = decryptedText
        }
    }
    @IBOutlet weak var deTextCell: UITableViewCell!
    
    @IBOutlet weak var plgbCell: UITableViewCell!
    @IBOutlet weak var plugboardLabel: UILabel! {
        didSet {
            if let e = enigma {
                plugboardLabel.text = EnigmaDisplayer.Plugboard(e.plugboard.pairs)
            }
        }
    }
    @IBOutlet weak var rotorsLabel: UILabel! {
        didSet {
            if let e = enigma {
                rotorsLabel.text = EnigmaDisplayer.Rotors(e)
            }
        }
    }
    
    @IBOutlet weak var positionsLabel: UILabel! {
        didSet {
            if let e = enigma {
                positionsLabel.text = EnigmaDisplayer.RotorPositions(e)
            }
        }
    }
    @IBOutlet weak var offsetLabel: UILabel! {
        didSet {
            if let e = enigma {
                offsetLabel.text = EnigmaDisplayer.RotorOffsets(e)
            }
        }
    }
    @IBOutlet weak var reflectorLabel: UILabel! {
        didSet {
            if let e = enigma {
                reflectorLabel.text = String(EnigmaDisplayer.Reflector(e))
            }
        }
    }
    private lazy var deTextCellIndexPath: NSIndexPath = { self.tableView.indexPathForCell(self.deTextCell) ?? NSIndexPath(forRow: 0, inSection: 0) }()
    
    private lazy var plgbCellIndexPath: NSIndexPath = { self.tableView.indexPathForCell(self.plgbCell) ?? NSIndexPath(forRow: 0, inSection: 1) }()
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell: UITableViewCell
        let label: UILabel
        if indexPath == deTextCellIndexPath {
            cell = deTextCell
            label = decryptedTextLabel
        } else if indexPath == plgbCellIndexPath {
            cell = plgbCell
            label = plugboardLabel
        } else {
            return tableView.rowHeight
        }
        label.preferredMaxLayoutWidth = tableView.bounds.width - 16
        return max(cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 5, tableView.rowHeight)
        
    }
}
