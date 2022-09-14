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
    @State private var selectedImage: UIImage?
    @State var imagePickerToggle: Bool = false
    @State var imageUploadFailed: Bool = false
    @State var writingFailed: Bool = false
    @State var text: String = ""
    @State var selectedFilter: Int = 5
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    func rotateImage(_ image: UIImage) -> UIImage? {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
    func submit(_ params: [String: Any]) {
        AF.request("\(api)/post/submit",
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 10 }
            .validate()
            .responseData { response in
                print(params)
                checkResponse(response)
                switch response.result {
                case .success: presentationMode.wrappedValue.dismiss()
                case .failure: writingFailed.toggle()
                }
            }
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
                    TextEditor(text: $text)
                        .font(.title3)
                        .setAlignment(for: .top)
                    if text.isEmpty {
                        Text("멘토에게 부탁할 내용을 입력하세요.")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .padding(.top, 8)
                            .padding(.leading, 6)
                            .setAlignment(for: .top)
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
            .padding()
            HStack(spacing: 0) {
                Button(action: {
                    let fileName: String = "\(Int((Date().timeIntervalSince1970 * 1000.0).rounded())).jpeg"
                    var reqParam: [String: Any] = ["content": text]
                    if selectedFilter != 5 {
                        reqParam["tag"] = TypeArray[selectedFilter].uppercased()
                    }
                    if selectedImage != nil {
                        AF.upload(multipartFormData: { MultipartFormData in
                            MultipartFormData.append(rotateImage(selectedImage!)!.jpegData(compressionQuality: 0.6)!,
                                                     withName: "file",
                                                     fileName: fileName,
                                                     mimeType: "image/jpeg")
                        }, to: "\(api)/file/upload") { $0.timeoutInterval = 10 }
                            .validate()
                            .responseData { response in
                                checkResponse(response)
                                switch response.result {
                                case .success:
                                    guard let value = response.value else { return }
                                    guard let result = try? decoder.decode(ImageData.self, from: value) else { return }
                                    reqParam["imgUrl"] = result.data.imgUrl
                                    submit(reqParam)
                                case .failure: imageUploadFailed.toggle()
                                }
                            }
                    } else {
                        submit(reqParam)
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
                .disabled(text.isEmpty || selectedFilter == 5)
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
        .alert(isPresented: $writingFailed) {
            Alert(title: Text("오류"), message: Text("멘토 요청에 실패했습니다"), dismissButton: .default(Text("확인")))
        }
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
