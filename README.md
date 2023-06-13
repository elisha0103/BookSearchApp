# BookSearchApp

### 프로젝트 소개
<img src = "https://user-images.githubusercontent.com/41459466/231796941-b32657ee-33b9-492d-acf9-43a611364c00.jpg">

### 프로젝트 목표
> - [Open Library Search API](https://openlibrary.org/dev/docs/api/search)를 사용해 책을 검색하기
> - [Open Library Covers API](https://openlibrary.org/dev/docs/api/covers)를 사용해 책 Cover 이미지 나타내기
> - Pagination 사용하여 무한 스크롤 사용해보기
> - Covers API로부터 받아온 이미지를 기기 메모리 / 디스크 캐시하여 자원 절약하기

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
- Pagination을 통해 스크롤을 화면 최하단으로 내리면 다음 데이터를 받아옴(추가 데이터가 없으면 반환 안함)
- URLSession을 통해 네트워크 통신이 되는동안 로딩 View를 구성함

## Feature-2. Cover Image 불러오기 구현
### 주요 기능
- 사용자가 TextField를 통해 검색된 도서에 관한 Cover이미지를 Covers API를 통해 데이터를 받아옴
- 최초 API를 통해 받아온 이미지 데이터를 메모리 / 디스크에 데이터 저장
- 이미지를 다시 호출할 때, 메모리로부터 데이터를 요청 -> (실패) -> 디스크로부터 메모리 요청 -> (실패) -> API를 통해 데이터 요청
- 검색 View에서 DetailView로 View가 이동할 때, DetailView에 보여지는 이미지도 이미지 캐싱을 통해 로드

### Cache 구현 결과 (이미지 응답 5000 ~ 10000배 빠른 성능향상)

|<img alt="이미지로드(네트워크)" src="https://github.com/elisha0103/BookSearchApp/assets/41459466/9dc9e3b5-427f-4fb2-aef2-0b07aea0a9ab" height="400"/></img>|<img  alt="이미지로드(캐시)" src="https://github.com/elisha0103/BookSearchApp/assets/41459466/937d0778-8b91-4015-92fb-bfe9cf4ced82" height="400"/></img>|
|:-:|:-:|
|`Network Image Load`|`NSCache Image Load`|
|`수행시간: 약 1초`|`수행시간: 약 0.0001초 ~ 0.0002초`|


## 구현 화면

|<img src="https://user-images.githubusercontent.com/41459466/231794900-aa9dbea2-42b8-4203-bdcb-075a98ea48a9.gif" width="200" height="400"/></img>|<img src="https://user-images.githubusercontent.com/41459466/231794632-95469519-27a7-4c7a-a3b3-96829101a0c8.gif" width="200" height="400"/></img>|
|:-:|:-:|
|`검색, 상세 화면`|`Pagination 구현 화면`|


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
    
    
- 문제: ContentView에서 NavigationLink로 DetailView로 이동한 경우, DetailView에서 가지고 있는 프로퍼티들이 State 관리가 되지 않음

- 원인: DetailView의 프로퍼티들이 State 변수로 선언되지 않음

- 해결: DetailView의 프로퍼티들을 바인딩 프로퍼티 래퍼를 사용하여 선언하고, NavigationLink로 DetailView로 연결시켜줄 때, ViewModel의 상태 프로퍼티들을 DetailView의 프로퍼티들과 바인딩해줌


### **Cache 관련**
- 배경: 이미지 캐시에 대한 Singleton 객체를 만들게 되면 여러 스레드에서 한 개의 객체에 NSCache 작업을 수행하게 되어 크래시가 발생할 것을 우려하여 각 이미지 View Struct 안에 MVVM형식(데이터 바인딩)을 취하는 방식으로 이미지 캐시 구현 시도

- 문제: 구조체 View안에서 NSCache가 제대로 저장되지 않는 문제

- 원인: NSCache가 사용되는 구조체 View가 LazyVGrid에 사용되는 View이고, NSCache 는 캐시 삭제시 NSDiscardableContent 프로토콜을 따르므로, 사용되지 않는 Content(LazyVGrid에서 보여지지 않는 View)에 해당하는 메모리는 자동 삭제 됨

- 해결: CacheManager 클래스를 싱글턴 아키텍처 적용하여 한 객체에서 NSCache 관리되도록 구현


### **URLSession 관련**
- 배경: API로부터 URLSession으로 이미지 로드가 미완료된 항목에 대해 중복된 요청이 발생될 수 있음

- 문제: 문제: URLSessionTask에 이미 요청된 작업 중 동일한 요청인지 먼저 비교하고 API에 데이터 로드를 할 수 없는 문제

- 원인
    - 1. URLSession으로 GET 데이터를 요청할 때, 비동기적으로 작업이 요청되고, URLSessionTask의 객체를 반환하는 URLSession.getAllTasks 함수도 비동기적으로 작업을 수행하기 때문에 sink가 맞지 않아 제대로 된 작업이 이뤄지지 않음
    - 2. URLSession의 기존 작업을 모두 취소하고 재요청을 보낼 수는 있지만, 이는 URLSessionTask Queue에 동일한 이미지 로드 요청건이 존재하지 않을 뿐이고 중복된 요청 자체를 API에 하지 않는 목적과는 다른 해결방법임
    - 3. URLSessionTask는 동일한 URL에 대한 과제일지라도, 과제에 대한 객체는 서로 다르기 때문에 비교대상이 될 수 없음

- 해결: CoverImageViewModel을 구현하여 CoverImageView에 대한 ViewModel 객체를 개별적으로 생성하고 ViewModel의 loadingState flag 변수를 사용하여 이미 API 함수가 호출된 경우 이미지 로드가 미완료 된 View에 한 해서는 중복된 요청 자체가 발생되지 않도록 함



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
   - 네트워크 추상화 계층 일치
   - 중복된 이미지 로드 요청 방지
   - 검색 하위 별로 Sub ViewModel로 상태 객체 관리
