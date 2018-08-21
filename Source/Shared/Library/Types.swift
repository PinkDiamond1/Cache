#if os(iOS) || os(tvOS)
  import UIKit
  public typealias Image = UIImage

    /// Helper UIImage extension.
    extension UIImage {
      /// Checks if image has alpha component
      var hasAlpha: Bool {
        let result: Bool

        guard let alpha = cgImage?.alphaInfo else {
          return false
        }

        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
          result = false
        default:
          result = true
        }

        return result
      }

      /// Convert to data
      func cache_toData() -> Data? {
        return hasAlpha
          ? UIImagePNGRepresentation(self)
          : UIImageJPEGRepresentation(self, 1.0)
      }
    }

#elseif os(watchOS)

#elseif os(OSX)
  import AppKit
  public typealias Image = NSImage

  /// Helper UIImage extension.
    extension NSImage {
      /// Checks if image has alpha component
      var hasAlpha: Bool {
        var imageRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        guard let imageRef = cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
          return false
        }

        let result: Bool
        let alpha = imageRef.alphaInfo

        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
          result = false
        default:
          result = true
        }

        return result
      }

      /// Convert to data
      func cache_toData() -> Data? {
        guard let data = tiffRepresentation else {
          return nil
        }

        let imageFileType: NSBitmapImageRep.FileType = hasAlpha ? .png : .jpeg
        return NSBitmapImageRep(data: data)?
          .representation(using: imageFileType, properties: [:])
      }
    }
#endif

