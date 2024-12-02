//
//  PerfumeInfo.swift
//  Perfuinder
//
//  Created by 석민솔 on 11/17/24.
//

import SwiftUI

/// 개별 향수 정보
struct PerfumeInfo: View {
    // MARK: - Properties    
    /// 뷰모델
    @StateObject var vm: PerfumeInfoViewModel
    
    // MARK: - Initializer
    init(perfumeID: Int) {
        _vm = StateObject(wrappedValue: PerfumeInfoViewModel(id: perfumeID))
    }
    
    // MARK: - View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                if let data = vm.data {
                    // 이미지
                    imageComponent(url: data.imageUrl)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // 기본정보: 브랜드, 향수 이름, 향수 전체 설명
                    basicInfoComponent
                    
                    // 가격
                    if !data.priceDTO.isEmpty {
                        priceComponent(priceSet: data.priceDTO)
                    }
                    
                    // 계절 | 성별
                    seasonGenderComponent
                    
                    Divider()
                    
                    // 키워드 토큰(보라색배경)
                    imageKeywordsComponent(keywords: data.keywords)
                    
                    // 대표노트(pure token)
                    mainNoteComponent(notes: data.mainNotes)
                    
                    // 탑/미들/베이스노트
                    noteInfoComponent(info: data.notes)
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, -15)
                    
                    // 유명인
                    if !data.celebrityDTO.isEmpty {
                        celebComponent(data.celebrityDTO)
                    }
                    
                } else {
                    ProgressView()
                }
            }
            .padding(.horizontal, 15)
        }
        .navigationTitle("향수 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 찜하기 상태변경 API 호출
                    vm.toggleFavorite()
                } label: {
                    Image(vm.data?.isFavorite ?? false ? "heart-fill" : "heart-empty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)   // 탭바 안보이도록
    }
}

extension PerfumeInfo {
    // MARK: 이미지 컴포넌트
    /// 향수 브랜드에 따라 이미지 크기 조정하기위한 변수
    var seasonPerfumeImageWidth: CGFloat {
        switch vm.data?.brand {
        case "JOMALONE":
            return 180
        case "FORMENT":
            return 230
        default:
            return 200
        }
    }
    
    /// 향수 브랜드가 포맨트이면 clipshape 해주기 위한 변수
    var seasonPerfumeClipShape: AnyShape {
        if vm.data?.brand == "FORMENT" {
            return AnyShape(Capsule())
        } else {
            return AnyShape(Rectangle())
        }
    }
    
    /// 향수 이미지 컴포넌트
    @ViewBuilder
    private func imageComponent(url: String) -> some View {
        VStack {
            URLImage(url: url)
                .frame(width: seasonPerfumeImageWidth, height: 160)
                .clipShape(seasonPerfumeClipShape)
                .clipped()
        }
    }
    
    // MARK: 기본정보 컴포넌트
    private var basicInfoComponent: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let data = vm.data {
                // 브랜드
                Text(data.brand)
                    .font(.subheadline)
                
                // 향수 이름
                Text(data.perfumeName)
                    .font(.headline)
                    .padding(.bottom, 15)
                
                // 향수 전체 설명
                Text(data.perfumeDesc)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    // MARK: 가격 컴포넌트
    /// 용량별 가격
    private func priceComponent(priceSet: [PriceEntity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            var index: Int {
                get {
                    vm.selectedPriceIndex
                }
                set(newIndex) {
                    vm.selectedPriceIndex = newIndex
                }
            }
            
            Text("\(priceSet[index].price)원")
            HStack {
                ForEach(priceSet, id: \.volume) { price in
                    volumeCapsule(volume: price.volume, selected: priceSet.firstIndex(where: {$0.volume == price.volume}) == index)
                        .onTapGesture {
                            index = priceSet.firstIndex(where: {$0.volume == price.volume})!
                        }
                }
            }
        }
    }
    
    /// 선택여부에 따라서 용량 캡슐모양 버튼으로 보여주기
    private func volumeCapsule(volume: Int, selected: Bool) -> some View {
        VStack {
            Text("\(volume)ml")
                .font(.caption)
                .fontDesign(.rounded)
                .foregroundStyle(selected ? Color.white : Color.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(selected ? Color.black : Color.unselected)
                )
        }
    }
    
    // MARK: 계절 | 성별 컴포넌트
    private var seasonGenderComponent: some View {
        HStack(alignment: .center, spacing: 20) {
            SeasonComponent(season: vm.data?.seasonCode ?? .spring)
                .frame(maxWidth: .infinity, alignment: .center)
            
            GenderComponent(gender: vm.data?.genderCode ?? .female)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    // MARK: 향수 이미지 키워드
    @ViewBuilder
    private func imageKeywordsComponent(keywords: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 향수 이미지 키워드 label
            Text("향수 이미지 키워드")
                .font(.headline)
            
            // 토큰들
            WrapLayout {
                ForEach(keywords, id: \.self) { keyword in
                    main10Token(text: keyword)
                }
            }
        }
    }
    
    /// 키워드 토큰(보라색배경)
    @ViewBuilder
    private func main10Token(text: String) -> some View {
        Text(text)
            .font(.footnote)
            .padding(.horizontal, 15)
            .padding(.vertical, 7)
            .foregroundStyle(Color.black)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.main10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
    
    // 대표노트(pure token)
    @ViewBuilder
    private func mainNoteComponent(notes: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 대표노트 label
            Text("대표노트")
                .font(.headline)
            
            // 토큰들
            WrapLayout {
                ForEach(notes, id: \.self) { note in
                    PureToken(text: note)
                }
            }
        }
    }
    
    // MARK: 탑/미들/베이스노트 컴포넌트
    private func noteInfoComponent(info: [InfoNoteModel]) -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 40) {
                ForEach(info, id: \.typeCode) { infoModel in
                    singleNoteInfoComponent(singleNoteInfo: infoModel)
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 15)
        }
    }
    
    
    /// 노트 종류 하나별로 보여줄 뷰
    private func singleNoteInfoComponent(singleNoteInfo: InfoNoteModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 노트종류 이름
            Text(singleNoteInfo.typeCode.text)
                .font(.headline)
            
            // 해당 노트 전체에 대한 설명
            Text(singleNoteInfo.desc)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            // 노트 토큰들
            ForEach(singleNoteInfo.notes, id: \.self) { note in
                PureToken(text: note)
            }
            
        }
        .frame(maxWidth: 150, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // MARK: 유명인 컴포넌트
    private func celebComponent(_ celebrityInfos: [CelebrityDTO]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 사용하는 유명인 lebel
            Text("사용하는 유명인")
                .font(.headline)
            
            // 유명인별 사진 & 이름 컴포넌트
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 30) {
                    ForEach(celebrityInfos, id: \.name) { celeb in
                        singleCelebrityCell(celeb)
                    }
                }
            }
        }
    }
    
    private func singleCelebrityCell(_ celeb: CelebrityDTO) -> some View {
        VStack {
            // 동그라미 크롭 이미지
            URLImage(url: celeb.url)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            // 유명인 이름
            Text(celeb.name)
                .font(.callout)
        }
    }
}

#Preview {
    PerfumeInfo(perfumeID: 1001)
}
