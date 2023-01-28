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
    @ViewBuilder func dragGesture(_ dismiss: DismissAction, _ dragOffset: GestureState<CGSize>) -> some View {
        self
            .gesture(DragGesture().updating(dragOffset, body: { (value, state, transaction) in
                 if(value.startLocation.x < 20 &&
                            value.translation.width > 100) {
                     dismiss()
                 }
            }))
    }
    
    @ViewBuilder func customCell(_ invert: Bool = false,
                                 bottom: Bool = false,
                                 decrease: Bool = false,
                                 trailing: Bool = true,
                                 leading: Bool = true,
                                 limit: Bool = false
    ) -> some View {
        self
            .frame(maxWidth: limit ? 500 : .infinity)
            .listRowSeparator(.hidden)
            //.frame(minHeight: 100)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(5)
            .customShadow(2)
            .padding(.leading, leading ? 20 : 10)
            .padding(.trailing, trailing ? 20 : 10)
            .padding(invert ? .bottom : .top, decrease ? 14 : 20)
            .padding(.bottom, bottom ? 20 : 0)
            //.listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)
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
    
    @ViewBuilder func customComment(_ leadingPadding: Bool = true) -> some View {
        self
            .setAlignment(for: .leading)
            .padding(10)
            .background(Color("M2MBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.leading, leadingPadding ? 65 : 0)
            .padding(.top, leadingPadding ? 5 : 0)
            .padding(leadingPadding ? [.trailing, .bottom] : [])
    }
    
    @ViewBuilder func customShadow(_ y: CGFloat = 0) -> some View {
        self
            .clipped()
            .shadow(color: .black.opacity(0.2), radius: 3, y: y)
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
    
    @ViewBuilder func exitAlert(_ status: Binding<Bool>) -> some View {
        self
            .alert(isPresented: status) {
                Alert(title: Text("오류"), message: Text("서버에 연결할 수 없습니다"),
                      dismissButton: Alert.Button.default(Text("확인"), action: {
                    exitHandler()
                }))
            }
    }
    
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    func placeholder<Content: View>(
       when shouldShow: Bool,
       alignment: Alignment = .leading,
       @ViewBuilder placeholder: () -> Content) -> some View {
           ZStack(alignment: alignment) {
               placeholder().opacity(shouldShow ? 1 : 0)
               self
       }
   }
    
    func placeholder(_ text: String, when shouldShow: Bool, alignment: Alignment = .leading) -> some View {
        placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.gray) }
    }
}

struct NothingView: View {
    var body: some View {
        Rectangle()
            .fill(.gray)
            .opacity(0.3)
    }
}

public let bottomPadding: CGFloat = (UIApplication
    .shared
    .connectedScenes
    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
    .first { $0.isKeyWindow }?.safeAreaInsets.bottom)!

public let topPadding: CGFloat = (UIApplication
    .shared
    .connectedScenes
    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
    .first { $0.isKeyWindow }?.safeAreaInsets.top)!
