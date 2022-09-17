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
    
    @ViewBuilder func tutorialFrame() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 15)
            .padding([.top, .bottom], 15)
    }
}
