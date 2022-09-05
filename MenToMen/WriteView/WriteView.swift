//
//  WriteView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI
import Alamofire

struct WriteView: View {
    @Environment(\.presentationMode) var presentationMode
    let decoder: JSONDecoder = JSONDecoder()
    @State private var selectedImage: UIImage?
    @State var imagePickerToggle: Bool = false
    @State var imageUploadFailed: Bool = false
    @State var text: String = ""
    @State var selectedFilter: Int = 5
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(Font.system(size: 25, weight: .regular))
                }
                .padding([.top, .trailing], 20)
            }
            VStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                       VStack {
                            Text("멘토에게 부탁할 내용을 입력하세요.")
                                .font(.title3)
                                .padding(.top, 8)
                                .padding(.leading, 6)
                                .opacity(0.5)
                            Spacer()
                        }
                    }
                    VStack {
                        TextEditor(text: $text)
                            .font(.title3)
                            .opacity(text.isEmpty ? 0.85 : 1)
                        Spacer()
                    }
                }
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
                Button(action: {
                    var imageUrl: String = ""
                    if selectedImage != nil {
                        AF.upload(multipartFormData: { MultipartFormData in
                            MultipartFormData.append(selectedImage!.jpegData(compressionQuality: 1)!,
                                                     withName: "photos[1]", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                        }, to: "\(api)/imageUpload") { $0.timeoutInterval = 10 }
                            .validate()
                            .responseData { response in
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? decoder.decode(ImageData.self, from: value) else { return }
                                    imageUrl = result.data.imageUrl
                                case .failure: imageUploadFailed.toggle()
                                }
                            }
                    }
                    AF.request("\(api)/upload",
                               method: .post,
                               parameters: imageUrl.isEmpty ? [:] : ["imageUrl": imageUrl],
                               encoding: JSONEncoding.default,
                               headers: ["Content-Type": "application/json"]
                    ) { $0.timeoutInterval = 10 }
                        .validate()
                        .responseData { response in
                            
                        }
                }) {
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
                .disabled(text.isEmpty)
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
                                .scaledToFill()
                                .frame(width: 55, height: 55)
                                .clipped()
                                //.ignoresSafeArea()
                                .overlay(.black.opacity(0.3))
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
            .padding(.bottom, 0.1)
        }
        .sheet(isPresented: $imagePickerToggle) {
            ImagePicker(image: $selectedImage)
        }
        .alert(isPresented: $imageUploadFailed) {
            Alert(title: Text("오류"), message: Text("이미지 업로드에 실패했습니다"), dismissButton: .default(Text("확인")))
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
