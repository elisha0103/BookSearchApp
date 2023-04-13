# BookSearchApp

### 프로젝트 소개
<img src = "https://user-images.githubusercontent.com/41459466/231796941-b32657ee-33b9-492d-acf9-43a611364c00.jpg">

### 프로젝트 목표
> [Open Library Search API](https://openlibrary.org/dev/docs/api/search)를 사용해 책을 검색하기
> [Open Library Covers API](https://openlibrary.org/dev/docs/api/covers)를 사용해 책 Cover 이미지 나타내기
> Pagenation을 사용하여 무한 스크롤 사용해보기
> Covers API로부터 받아온 이미지를 기기 메모리 / 디스크 캐시하여 자원 절약하기

### 개발 환경
- Deployment Target: iOS 14.1
- Architecture: MVVM, Singleton


## Foldering
```
BookSearchApp
├── App
├── View
│   ├── CustomUI
│   ├── BooksSearchView
│   └── BookDetailView
├── Extension
├── Architecture
│   ├── ViewModel
│   └── Singleton
├── Model
├── Preview Content
└── Preview Content
BookSearchAppTests
BookSearchSlowTests
BookSearchAppUITests
```

## Feature-1. 검색화면 구현
### 주요 기능
- 사용자가 TextField에 입력한 Text를 바탕으로 검색 결과를 받아옴
- URLSession을 통해 네트워크 통신 구현 (테스트 코드를 통해 실행)
- Pagenation을 통해 스크롤을 화면 최하단으로 내리면 다음 데이터를 받아옴(추가 데이터가 없으면 반환 안함)
- URLSession을 통해 네트워크 통신이 되는동안 로딩 View를 구성함

## Feature-2. Cover Image 불러오기 구현
### 주요 기능
- 사용자가 TextField를 통해 검색된 도서에 관한 Cover이미지를 Covers API를 통해 데이터를 받아옴
- 최초 API를 통해 받아온 이미지 데이터를 메모리 / 디스크에 데이터 저장
- 이미지를 다시 호출할 때, 메모리로부터 데이터를 요청 -> (실패) -> 디스크로부터 메모리 요청 (실패) -> API를 통해 데이터 요청
- 검색 View에서 DetailView로 View가 이동할 때, DetailView에 보여지는 이미지도 이미지 캐싱을 통해 로드


## 구현 화면

|<img src="https://user-images.githubusercontent.com/41459466/231794900-aa9dbea2-42b8-4203-bdcb-075a98ea48a9.gif"></img>|<img src="https://user-images.githubusercontent.com/41459466/231794632-95469519-27a7-4c7a-a3b3-96829101a0c8.gif"></img>|
|:-:|:-:|
|`검색, 상세 화면`|`Pagenation 구현 화면`|


## Troubleshooting
### **View 관련**

<img src="https://user-images.githubusercontent.com/41459466/231787564-068a7e76-2f8f-4e3d-a1c4-c62db49e089d.png" width="200" height="400"/>

- 문제: LazyVGrid 각 아이템 내 VStack(alignment: .leading) 정렬이 적용되지 않음

- 원인: LazyVGrid에 각 아이템(셀)별로 부여되는 컨테이너 영역의 정렬이 필요
 
<img src="https://user-images.githubusercontent.com/41459466/231787651-8878b4c1-9d58-4a0d-9eb9-2a639e36f276.png" width="200" height="400"/>

- 해결: VStack의 ViewBuilder 정렬 값뿐만 아니라 컨테이너 .frame에도 정렬 수정자 적용 
    ```
    .frame(maxWidth: .infinity, alignment: .leading)
    ```

### **Cache 관련**
- 배경: 이미지 캐시에 대한 ViewModel을 만들게 되면 여러 스레드에서 한 개의 ViewModel, NSCache를 사용하게 되어 크래시가 발생할 경우를 우려하여 각 이미지 View Struct 안에 MVVM형식(데이터 바인딩)을 취하는 방식으로 이미지 캐시 구현 시도

- 문제: 구조체 View안에서 NSCache가 제대로 저장되지 않는 문제

- 원인: NSCache가 사용되는 구조체 View가 LazyVGrid에 사용되는 View이고, NSCache 는 캐시 삭제시 NSDiscardableContent 프로토콜을 따르므로, 사용되지 않는 Content(LazyVGrid에서 보여지지 않는 View)에 해당하는 메모리는 자동 삭제 됨

- 해결: CacheManager 클래스를 싱글턴 아키텍처 적용하여 한 객체에서 NSCache 관리되도록 구현


## 참고사항
<details>
<summary>코드 컨벤션</summary>
<div markdown="1">

- Swiftlint 적용

- 네이밍
    - 일반변수 / 상수인 경우 따로 접두사를 붙이지 않는다.
    - enum case는 대문자로 시작한다.
    - 일반적인 부분이 앞에, 구체적인 부분을 뒤에 둬 모호함을 없앤다.
    - 클래스 함수에는 되도록 get을 붙이지 않는다.
    - 액션 함수는 ‘주어 + 동사 + 목적어’ 형태를 사용한다.
    - 약어로 시작하는 경우 소문자로 표기하고, 그 외 경우에는 항상 대문자로 표기한다.    
    - 디자인 컨셉을 통일하고 진행했으면 전체적인 디자인을 구성하는데 효율적일거 같다.
    
- 기타
    - 클로저 정의시 파라미터에는 괄호를 사용하지 않는다.
    - 클로저 정의시 가능한 경우 타입 정의를 생략한다.
    - 사용하지 않는 파라미터는 삭제하거나 _를 사용해 표시한다.
    - 구조체 생성시 Swift 구조체 생성자를 사용한다.
    - Array<T>, Dictionary<T: U> 보다는 [T], [T: U]를 사용한다.
    - 언어에서 필수로 요구하지 않는 이상 self는 사용하지 않는다.
    - 프로퍼티의 초기화는 가능하면 init에서 하고, unwrapped Optional의 사용을 지양한다.
    - 더이상 상속이 발생하지 않는 클래스는 항상 final 키워드로 선언한다.
    - switch - case 에서 가능한 경우 default를 사용하지 않는다.
    - return은 사용하지 않는다.
    - 사용하지 않는 코드는 주석 포함 모두 삭제한다.

</div>
</details>

<details>
<summary>Git 컨벤션</summary>
<div markdown="1">

- Feat: 새로운 기능을 추가하 경우
- Fit: 버그를 고친경우
- Design: 사용자 UI 디자인 추가 및 변경
- Style: 코드 포매 변경, 세미 콜로 누락, 코드 수정이 없는 경우
- Refactor: 프로덕션 코드 리펙토링
- Comment: 필요한 주석 추가 및 변경
- Documents: 문서를 수정한 경우
- Test: 테스트 추가, 테스트 리펙토링
- Rename: 파일 혹은 폴더명을 수정하거나 옮기는 작업만 한 경우
- Remove: 파일으 삭제한 작업만 수행한 경우

</div>
</details>

[DataTable](https://fern-collar-1c6.notion.site/DataTable-3de671e2398d403f81b106e644a338e4)


## 활용기술

#### Platforms

<img src="https://img.shields.io/badge/iOS-5A29E4?style=flat&logo=iOS&logoColor=white"/>  
    
#### Language & Tools

<img src="https://img.shields.io/badge/Xcode-147EFB?style=flat&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/SwiftUI-2396F3?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white"/>



## 보완할 점
   - 사용자 검색 요청시 debounce 적용하여 연속 검색을 방지
   - UI 테스트 코드 작성 (자동화)
