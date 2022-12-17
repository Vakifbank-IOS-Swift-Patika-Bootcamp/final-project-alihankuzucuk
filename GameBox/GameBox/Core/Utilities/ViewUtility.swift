//
//  ViewUtility.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit
import ImageSlideshow

// MARK: - Enums
// MARK: ImageIconType
enum ImageIconType {
    case systemImage
    case resourceImage
}

// MARK: - ViewUtility
final class ViewUtility {
    
    // MARK: - setImageInputs
    /// Sets Image Inputs to the given imageSlideshow
    /// - Parameters:
    ///   - imageSlideshow: Current imageSlideshow of you want to use
    ///   - gameId: Id of the game which game's screenshot will be showed
    static func setImageInputs(_ imageSlideshow: inout ImageSlideshow, gameId: Int) {
        RawGClient.getGameScreenshots(gameId: gameId) { [weak imageSlideshow] screenshots, error in
            guard let screenshots = screenshots else { return }
            
            var imageSlideshowInputSource: [InputSource] = []
            
            screenshots.results?.forEach({ screenshot in
                imageSlideshowInputSource.append(AlamofireSource(url: URL(string: screenshot.image)!))
            })
            
            imageSlideshow?.setImageInputs(imageSlideshowInputSource)
            imageSlideshow?.slideshowInterval = 3
            imageSlideshow?.contentScaleMode = UIViewContentMode.center
        }
    }
    
    // MARK: - labelWithBoldAndNormalText
    /// Combines bold text and normal text at once for properties
    /// - Parameters:
    ///   - label: Current label of you want to use
    ///   - boldText: Bold text
    ///   - normalText: Normal text
    static func labelWithBoldAndNormalText(_ label: inout UILabel, boldText: String, normalText: String) {
        let attributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let boldString = NSMutableAttributedString(string: boldText.localized, attributes: attributes)
        let normalString = NSMutableAttributedString(string: normalText)
        let resultString = NSMutableAttributedString()
        
        resultString.append(boldString)
        resultString.append(normalString)
        
        label.attributedText = resultString
    }
    
    // MARK: - labelWithImageAttachment
    /// Creates label with image attachment
    /// - Parameters:
    ///   - label: Current label of you want to use
    ///   - imageIconType: Type of where the code will search image
    ///   - imageName: Name of image
    ///   - text: Text of label
    ///   - textColor: Color of text
    static func labelWithImageAttachment(_ label: inout UILabel, imageIconType: ImageIconType, imageName: String, text: String, textColor: UIColor) {
        let completeText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        
        switch imageIconType {
            case .systemImage:
                imageAttachment.image = UIImage(systemName: imageName)?.withTintColor(textColor)
            case .resourceImage:
                imageAttachment.image = UIImage(named: imageName)
        }
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 30, height: 30)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        completeText.append(attachmentString)
        
        let textAfterIconAttributes = [NSAttributedString.Key.foregroundColor : textColor,
                                       NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let textAfterIcon = NSAttributedString(string: text, attributes: textAfterIconAttributes)
        
        completeText.append(textAfterIcon)
        
        label.textAlignment = .center
        label.attributedText = completeText
    }
    
}
