//
//  Extentions.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 10.08.2024.
//

import SwiftUI


enum Tabs {
    case Home
    case Bid
    case AddBid
    case Approved
    case Profile
}

enum Edit {
    case Wait
    case EditWait
    case Approve
    case NotApprove
    case Finished
    case Detail
}


enum FormTitle: String {
    case none = ""
    case companyName = "FİRMA İSMİ"
    case companyAddress = "ADDRES"
    case companyPhone = "TELEFON"
    case projeNumber = "PROJE ID"
    case workName = "İŞ İSMİ"
    case workDescription = "İŞ AÇIKLAMA"
    case workPrice = "İŞ FİYATI"
    case recMoney = "ALINAN PARA"
    case remMoney = "KALAN"
    case expMoney = "ALINACAK PARA"
    case recDate = "TAHSİLAT TARİHİ"
    case expDate = "VADE TARİHİ"
    case startDate = "BAŞLAMA TARİHİ"
    case finishDate = "TAHMİNİ BİTİŞ TARİHİ"
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func getRect() -> CGSize {
        return UIScreen.main.bounds.size
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().padding(.leading).opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}

extension UIView {
    func allSubviews() -> [UIView] {
        var allSubviews = subviews
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews())
        }
        return allSubviews
    }
}


extension UITabBar {
    private static var originalY: Double?

    static public func changeTabBarState(shouldHide: Bool) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ view in
            if let tabBar = view as? UITabBar {
                if let superview = tabBar.superview {
                    tabBar.snapshotView(afterScreenUpdates: true)
                    superview.snapshotView(afterScreenUpdates: true)
                    if !tabBar.isHidden && shouldHide {
                        originalY = superview.frame.origin.y
                        superview.frame.origin.y = superview.frame.origin.y + 4.5
                    } else if tabBar.isHidden && !shouldHide {
                        guard let originalY else {
                            return
                        }
                        superview.frame.origin.y = originalY
          
                    }
                    
                    tabBar.isHidden = shouldHide
                    tabBar.setNeedsLayout()
                    tabBar.layoutIfNeeded()
                    superview.setNeedsLayout()
                    superview.layoutIfNeeded()
                }
            }
        })
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}


/* old hidden tab
 extension UIView {
     func allSubviews() -> [UIView] {
         var subs = self.subviews
         for subview in self.subviews {
             let rec = subview.allSubviews()
             subs.append(contentsOf: rec)
         }
         return subs
     }
 }
 
 struct TabBarModifier {
     static func showTabBar() {
         UIApplication.shared.key?.allSubviews().forEach({ subView in
             if let view = subView as? UITabBar {
                 view.isHidden = false
             }
         })
     }
     
     static func hideTabBar() {
         UIApplication.shared.key?.allSubviews().forEach({ subView in
             if let view = subView as? UITabBar {
                 view.isHidden = true
             }
         })
     }
 }

 struct ShowTabBar: ViewModifier {
     func body(content: Content) -> some View {
         return content.padding(.zero).onAppear {
             TabBarModifier.showTabBar()
         }
     }
 }
 struct HiddenTabBar: ViewModifier {
     func body(content: Content) -> some View {
         return content.padding(.zero).onAppear {
             TabBarModifier.hideTabBar()
         }
     }
 }

 extension View {
     
     func showTabBar() -> some View {
         return self.modifier(ShowTabBar())
     }

     func hiddenTabBar() -> some View {
         return self.modifier(HiddenTabBar())
     }
 }
 */
