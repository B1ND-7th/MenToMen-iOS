//
//  ViewExtensions.swift
//  MenToMen
//
//  Created by Mercen on 2022/09/14.
//

import SwiftUI

enum Alignments {
    case top
    case bottom
    case leading
    case trailing
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove { self.hidden() }
        } else { self }
    }
    
    @ViewBuilder func dragGesture(_ dismiss: DismissAction, _ dragOffset: GestureState<CGSize>) -> some View {
        self
            .gesture(DragGesture().updating(dragOffset, body: { (value, state, transaction) in
                 if(value.startLocation.x < 20 &&
                            value.translation.width > 100) {
                     dismiss()
                 }
            }))
    }
    
    @ViewBuilder func customCell(_ invert: Bool = false, bottom: Bool = false) -> some View {
        self
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
            //.frame(minHeight: 100)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(15)
            .padding([invert ? .bottom : .top, .leading, .trailing], 20)
            .padding(.bottom, bottom ? 20 : 0)
            .listRowInsets(EdgeInsets())
            .background(Color("M2MBackground"))
    }
    
    @ViewBuilder func customListColor() -> some View {
        self
            .listStyle(PlainListStyle())
            .background(Color("M2MBackground"))
    }
    
    @ViewBuilder func customList() -> some View {
        if #available(iOS 16.0, *) {
            self
                .customListColor()
                .scrollContentBackground(.hidden)
        } else {
            self
                .customListColor()
        }
    }
    
    @ViewBuilder func setAlignment(for alignment: Alignments) -> some View {
        switch alignment {
        case .top: VStack {
            self
            Spacer()
        }
        case .bottom: VStack {
            Spacer()
            self
        }
        case .leading: HStack {
            self
            Spacer()
        }
        case .trailing: HStack {
            Spacer()
            self
        }
        }
    }
    
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let view = controller.view
        let renderer = UIGraphicsImageRenderer(bounds: view!.bounds)
        let image = renderer.image { rendererContext in
            view!.layer.render(in: rendererContext.cgContext)
        }
        
        controller.view.removeFromSuperview()
        return image
    }
}
