//
//  WriteView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI

struct WriteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: UIImage?
    @State var imagePickerToggle: Bool = false
    @State var text: String = ""
    @State var selectedFilter: Int = 5
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Button("Dismiss Modal") {
                    presentationMode.wrappedValue.dismiss()
                }
                TextEditor(text: $text)
                Spacer()
                HStack {
                    ForEach(0..<5, id: \.self) { idx in
                        Button(action: {
                                selectedFilter = selectedFilter == idx ? 5 : idx
                        }) {
                            ZStack {
                                switch(selectedFilter) {
                                    case idx: Capsule()
                                        .fill(Color("\(TypeArray[idx])CR"))
                                    case 5: Capsule()
                                        .fill(Color("\(TypeArray[idx])CR"))
                                    default: Capsule()
                                        .strokeBorder(Color("\(TypeArray[idx])CR"), lineWidth: 1)
                                }
                                Text(TypeArray[idx])
                                    .font(.caption)
                                    .foregroundColor(selectedFilter == idx || selectedFilter == 5 ? .white : Color("\(TypeArray[idx])CR"))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 25)
                        }
                    }
                }
            }
            .padding(20)
            HStack(spacing: 0) {
                Button(action: { print("a") }) {
                    HStack {
                        Image("write")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text("멘토 요청하기")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                }
                Button(action: {
                    if selectedImage == nil {
                        imagePickerToggle.toggle()
                    } else {
                        selectedImage = nil
                    }
                }) {
                    ZStack {
                        ZStack {
                            Image(uiImage: selectedImage ?? UIImage(named: "null")!)
                                .resizable()
                                .aspectRatio(contentMode: (selectedImage ?? UIImage(named: "null")!).size.height
                                             >= (selectedImage ?? UIImage(named: "null")!).size.width ? .fit : .fill)
                                .frame(width: 55)
                                .clipped()
                                .ignoresSafeArea()
                                .overlay(.black.opacity(0.5))
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .isHidden(selectedImage == nil, remove: true)
                        Image("photo")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .isHidden(selectedImage != nil, remove: true)
                    }
                    .foregroundColor(Color(.systemBackground))
                    .frame(width: 55, height: 55)
                    .background(Color(.label))
                }
            }
        }
        .sheet(isPresented: $imagePickerToggle) {
            ImagePicker(image: $selectedImage)
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
