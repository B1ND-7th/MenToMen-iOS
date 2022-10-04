//
//  WriteView.swift
//  MenToMen
//
//  Created by Mercen on 2022/08/26.
//

import SwiftUI
import Alamofire

struct WriteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImage: [UIImage] = [UIImage]()
    @State private var tempImage: [UIImage] = [UIImage]()
    @State var imagePickerToggle: Bool = false
    @State var imageUploadFailed: Bool = false
    @State var writingFailed: Bool = false
    @State var text: String = ""
    @State var selectedFilter: Int = 5
    @State var imageEdited: Bool = false
    let TypeArray: [String] = ["Design", "Web", "Android", "Server", "iOS", ""]
    let data: PostDatas?
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
        AF.request("\(api)/post/\(data == nil ? "submit" : "update")",
                   method: data == nil ? .post : .patch,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"],
                   interceptor: Requester()
        ) { $0.timeoutInterval = 5 }
            .validate()
            .responseData { response in
                print(params)
                checkResponse(response)
                switch response.result {
                case .success: dismiss()
                case .failure: writingFailed.toggle()
                }
            }
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
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
                            withAnimation(.default) {
                                selectedFilter = selectedFilter == idx ? 5 : idx
                            }
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
            if !selectedImage.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 17) {
                        ForEach(selectedImage, id: \.self) { img in
                            ZStack {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 75, height: 75)
                                Button(action: {
                                    withAnimation(.default) {
                                        selectedImage = selectedImage.filter { $0 != img }
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.caption)
                                        .padding(5)
                                        .foregroundColor(.white)
                                        .background(.black.opacity(0.5))
                                        .setAlignment(for: .trailing)
                                        .setAlignment(for: .top)
                                }
                            }
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                        }
                    }
                    .padding([.leading, .trailing])
                }
                .padding(.bottom)
            }
            HStack(spacing: 0) {
                Button(action: {
                    let fileName: String = "\(Int((Date().timeIntervalSince1970 * 1000.0).rounded())).jpeg"
                    var reqParam: [String: Any] = ["content": text]
                    if selectedFilter != 5 {
                        reqParam["tag"] = TypeArray[selectedFilter].uppercased()
                    }
                    if data != nil {
                        reqParam["postId"] = data!.postId
                    }
                    if !selectedImage.isEmpty ||
                        (!selectedImage.isEmpty && data != nil && imageEdited) {
                        AF.upload(multipartFormData: { MultipartFormData in
                            for img in selectedImage {
                                MultipartFormData.append(rotateImage(img)!.jpegData(compressionQuality: 0.6)!,
                                                         withName: "file",
                                                         fileName: fileName,
                                                         mimeType: "image/jpeg")
                            }
                        }, to: "\(api)/file/upload") { $0.timeoutInterval = 5 }
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
                    } else if data != nil && !imageEdited && data!.imgUrl != nil {
                        reqParam["imgUrl"] = data!.imgUrl!
                    } else {
                        submit(reqParam)
                    }
                }) {
                    HStack {
                        Image("write")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text(data == nil ? "멘토 요청하기" : "요청 수정하기")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                }
                .disabled(text.isEmpty || selectedFilter == 5)
                if selectedImage.count != 5 {
                    Button(action: {
                        imagePickerToggle.toggle()
                        imageEdited = true
                    }) {
                        Image("photo")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(.systemBackground))
                            .frame(width: 55, height: 55)
                            .background(Color(.label))
                    }
                }
            }
            .clipped()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            if data != nil {
                text = data!.content
                for idx in 0..<TypeArray.count {
                    if data!.tag == TypeArray[idx].uppercased() {
                        selectedFilter = idx
                    }
                }
//                if data!.imgUrl != nil {
//                    DispatchQueue.global().async {
//                        let data = try? Data(contentsOf: URL(string: data!.imgUrl!)!)
//                        DispatchQueue.main.async {
//                            if data != nil {
//                                selectedImage = UIImage(data: data!)
//                            }
//                        }
//                    }
//                }
            }
        }
        .sheet(isPresented: $imagePickerToggle) {
            PhotoPicker(images: $tempImage, selectionLimit: 5 - selectedImage.count)
                .ignoresSafeArea(edges: .bottom)
                .onDisappear {
                    withAnimation(.default) {
                        selectedImage += tempImage
                    }
                }
        }
        .alert(isPresented: $imageUploadFailed) {
            Alert(title: Text("오류"), message: Text("이미지 업로드에 실패했습니다"), dismissButton: .default(Text("확인")))
        }
        .alert(isPresented: $writingFailed) {
            Alert(title: Text("오류"), message: Text("멘토 요청에 실패했습니다"), dismissButton: .default(Text("확인")))
        }
    }
}
