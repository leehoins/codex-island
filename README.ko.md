# CodexIsland

[English](README.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md)

<p align="center">
  <img src="Assets/codexisland-logo.png" width="160" alt="CodexIsland logo">
</p>

<p align="center">
  <a href="https://hits.sh/github.com/ericjypark/codex-island/">
    <img alt="README visitors" src="https://hits.sh/github.com/ericjypark/codex-island.svg?label=visitors&color=007ec6&labelColor=555555">
  </a>
</p>

> AI 사용 한도를 노치 안에서 확인한다.

CodexIsland는 맥북 노치를 Claude Code와 Codex 사용 한도를 위한 다이나믹 아일랜드 스타일 라이브 액티비티로 바꿔주는 네이티브 macOS 오버레이다. 노치 위에 조용히 자리 잡고, 마우스를 올리면 5시간 요약이 살짝 나타나며, 클릭하면 확장되어 두 제공자의 5시간 및 주간 윈도우와 초기화 시점, 차트 컨트롤, 로컬 로그 기반 비용 추정, 연간 사용 기록을 한눈에 보여준다.

https://github.com/user-attachments/assets/195beeff-0f70-4d6b-8f3d-9f31d9c0b989


이 앱은 무료이며 오픈 소스이고, 서명되지 않았으며 로컬 우선으로 동작한다. Claude Code / Claude Desktop과 Codex가 이미 기록해 둔 자격 증명을 읽은 뒤, 각 제공자의 사용량 엔드포인트만 호출한다.
## 주요 기능

- **두 개의 제공자, 네 개의 윈도우.** Claude 5h + 7d와 Codex 5h + 7d를 하나의
  패널에서 확인한다.
- **노치 네이티브 오버레이.** 축소 상태는 물리적 노치에 정렬된 검은 알약 형태이며,
  하드웨어와 일치하는 연속 곡률(스쿼클) 모서리로 그려진다. 노치가 없는 디스플레이에서는
  설정 가능한 메뉴 막대 알약으로 대체된다.
- **호버로 미리보기.** 실루엣이 각 표시 중인 제공자의 5시간 사용률과 리셋 헤드라인을
  보여줄 만큼만 넓어지며, **항상 사용량 표시**를 켜면 대기 상태에서도 해당 헤드라인이
  계속 보인다.
- **스와이프 가능한 세 개의 화면.** 클릭해 확장한 뒤 **Usage**, **Cost**,
  **Overview** 사이를 스와이프한다. Cost는 로컬 Claude Code, Codex CLI, OpenCode
  세션 데이터를 기반으로 오늘과 월 누적 지출 및 토큰 처리량을 추정한다. Overview는
  사용량 알약에 어떤 제공자가 선택되어 있든 관계없이 지원되는 모든 제공자의 로그를
  사용해 올해 활동을 컨트리뷰션 형태의 캘린더로 렌더링한다. 캘린더 범례에서 제공자를
  클릭하면 해당 이력만 필터링되고, 다시 클릭하면 모든 제공자가 표시된다.
- **공유할 만한 사용량 카드.** **Overview → Share usage** 또는
  **Settings → General → Usage card**를 연다. 추정 API 가치를 USD로 전면에
  배치하고 누적 흐름 차트와 제공자별 금액을 함께 보여주거나, 토큰 수를 강조할 수
  있다. 카드 색상은 성과에 따라 결정된다. 선택한 지표 기준으로 $1K / 100M 토큰 미만은
  White, $1K / 100M부터는 Black, $10K / 1B부터는 Blue다. **Last 7 days**,
  **Last 30 days**, **Last 3 months**, **This year**, **All time** 중에서 고를 수
  있다. 기본값은 Last 7 days다. 7일 및 30일 범위는 오늘과 이전 6일 또는 29일을
  포함한다. Last 3 months는 오늘로 끝나는 롤링 캘린더 구간이다. This year는 오늘까지
  집계하며, All time은 필요할 때 로컬에 남아 있는 가장 오래된 사용 기록까지 읽는다.
  피드 / 정사각형 / 스토리 형식과 선택적 서명을 고른 뒤 macOS 공유 메뉴를 통해 이미지와
  캡션을 공유한다. 더 자세히 보려면 **Actual size**를, 1080픽셀 너비 PNG로 저장하거나
  이미지와 캡션을 복사하려면 **…** 메뉴를 사용한다. 앱 업데이트 후에는 주간 사용량이
  준비되면 카드가 한 번 열린다. 수치는 로컬 캘린더를 따르며 캐시 사용량을 포함한다.
  API 가치는 추정치이며 구독 청구서가 아니다. 가격 정보가 없는 항목은 부분 집계로
  표시된다. 모든 렌더링은 당신의 Mac에서 이루어진다.
- **온전히 당신 것인 사용 이력.** CodexIsland는 캡처한 토큰 수를 자체 로컬
  데이터베이스에 저장하며, 스캔 시점에 남아 있는 과거 기록도 함께 보관한다. 제공자
  로그 정리로 캡처된 이력이 지워지지 않는다. 반복 스캔은 동일한 호출을 다시 세지 않고
  갱신한다. 적용 범위는 [usage-history storage](docs/USAGE-HISTORY.md)를 참고한다.
  **Settings → General → Recover Claude usage…**를 열면 남아 있는 로그, 백업, 예전
  일별 스냅샷에서 검증된 수치를 가져오기 전에 미리 볼 수 있다.
  [터미널 스크립트](docs/USAGE-HISTORY.md#recover-your-claude-usage)도 포함되어 있다.
- **사용량 또는 잔여 할당량.** 제공자 윈도우를 소비한 사용량 또는 남은 할당량으로
  표시한다.
- **한도 임박 알림.** 선택적 경고 및 위험 임계값을 설정하면, 표시 중인 5시간 윈도우가
  한도에 가까워질 때 아일랜드에 색조가 입혀지고 미리보기 알약이 맥동한다.
- **Codex 리셋 크레딧.** 리셋 크레딧이 있으면 Usage 푸터에 개수와 만료 정보가 표시된다.
- **설정 가능한 토큰 집계.** TOKENS 영역은 네트워크를 오간 모든 토큰 유형을 합산하거나
  (캐시 포함, ccusage와 동일) 입력 + 출력만 합산할 수 있다. 후자는 Anthropic의
  claude.ai 통계 패널과 일치한다.
- **아일랜드 바깥 클릭 통과.** 창은 보이는 실루엣 바깥의 마우스 이벤트를 무시하므로
  메뉴 막대와 아래쪽 앱이 그대로 동작한다.
- **다섯 가지 차트 스타일.** Ring, Bar, Stepped, Numeric, Sparkline. 기본값은
  Settings에서 선택하거나 확장된 패널을 Command-클릭해 순환시킨다. Sparkline은
  CodexIsland가 새로고침에 성공할 때 기록한 실제 측정값을 사용한다.
- **즉시 새로고침.** 패널 헤더의 `synced Xs ago`를 클릭하면 바로 다시 가져오며,
  다음 예약 폴링은 그 시점부터 다시 설정된다.
- **코발트 글로우 + Low Power Mode.** 아일랜드 주위의 부드러운 글로우는 진행 중인
  새로고침을 뜻한다. Low Power Mode는 상시 글로우를 숨기고 실제 작업 중에만 맥동하게
  한다.
- **Dock 아이콘 없는 설정.** 확장 패널의 조용한 톱니바퀴 아이콘이 General, Display,
  Providers 탭을 갖춘 커스텀 크기 조절형 설정 창을 연다.
- **영어와 중국어 간체.** macOS 언어를 자동으로 따르거나 Settings에서 언어를 선택한다.
- **디스플레이 선택.** 노치가 있는 디스플레이를 자동 선택하거나 특정 연결 디스플레이에
  아일랜드를 고정한다. 노치가 없는 디스플레이는 컴팩트 및 노치 스타일 너비를 제공한다.
- **설정 가능한 안전 폴링.** 5m, 15m, 30m 중에서 선택한다. Anthropic이 사용량
  엔드포인트에 공격적인 속도 제한을 적용하므로 5분 미만 폴링은 제공하지 않는다.
- **유니버설 바이너리.** `build.sh`는 arm64와 x86_64 슬라이스를 컴파일해 `lipo`로
  병합하며, macOS 13+를 타깃으로 한다.
- **Sparkle을 통한 자동 업데이트.** 앱은 최신 GitHub Release에 첨부된 appcast를
  백그라운드에서 확인한 뒤 설치 전에 사용자에게 묻는다. 업데이트는 EdDSA 키로
  서명되어 Apple의 서명 인프라 없이도 검증할 수 있다. 특정 버전에 고정하고 싶다면
  Settings에서 자동 확인을 끈다.
- **네이티브 앱 프라이버시.** 앱 텔레메트리, 크래시 리포팅, 서드파티 앱 분석, 프록시
  서비스가 전혀 없다.
## 설치

### Homebrew

```sh
brew install --cask ericjypark/tap/codexisland
```

최초 실행 시 `ericjypark/homebrew-tap`이 자동으로 탭된다. cask가 Gatekeeper
quarantine 속성을 자동으로 제거한다(CodexIsland는 Apple 서명이 없으며 —
Sparkle이 업데이트 검증을 독립적으로 처리한다).

### 직접 다운로드

[최신 릴리스](https://github.com/ericjypark/codex-island/releases/latest)에서
현재 버전의 `CodexIsland-X.Y.Z.dmg`를 다운로드하고, 앱을 `/Applications`로
드래그한 다음 실행한다:

```sh
xattr -dr com.apple.quarantine /Applications/CodexIsland.app
```

<details>
<summary>quarantine 해제 명령이 왜 필요한가?</summary>

CodexIsland는 서명되어 있지 않다. Apple이 Developer ID 인증서에 연간 $99를
청구하는데 이 프로젝트는 무료 오픈소스이기 때문이다. 이 명령은 "Apple이 악성
소프트웨어 여부를 확인할 수 없어 열 수 없습니다" 경고를 유발하는 macOS
Gatekeeper quarantine 속성을 제거한다. 소스 코드는 감사할 수 있도록 이
저장소에 공개되어 있다.

[GitHub Sponsors](https://github.com/sponsors/ericjypark)를 통해 후원받은
Apple Developer ID를 확보하면 서명된 빌드를 제공할 수 있다.
</details>

<details>
<summary>터미널을 쓰고 싶지 않다. 어떻게 하나?</summary>

1. `CodexIsland.app`을 `/Applications`로 드래그한다.
2. 앱을 열어본다. 빌드가 서명되지 않았기 때문에 macOS가 차단한다.
3. **시스템 설정 -> 개인정보 보호 및 보안**을 연다.
4. 맨 아래로 스크롤해 차단된 CodexIsland 메시지를 찾는다.
5. **그래도 열기**를 클릭한 뒤 앱을 다시 실행한다.
</details>
## 최초 실행

CodexIsland는 비밀번호나 API 키를 요구하지 않는다. 이미 사용 중인 커맨드라인 도구나 데스크톱 앱이 생성해 둔 인증 상태를 읽는다.

Codex의 경우:

- 먼저 Codex / ChatGPT CLI에 로그인한다.
- CodexIsland는 `~/.codex/auth.json`을 읽는다.
- 파일이나 액세스 토큰이 없으면 패널에 `no codex auth`가 표시된다.

Claude의 경우:

- `claude`를 한 번 실행하거나 Claude Desktop을 열어 Claude 자격 증명이 채워지도록 한다.
- CodexIsland는 `CLAUDE_CODE_OAUTH_TOKEN`을 먼저 확인하고, 그다음
  `$CLAUDE_CONFIG_DIR/.credentials.json`(보통
  `~/.claude/.credentials.json`), 마지막으로 `Claude Code-credentials`라는
  이름의 macOS 키체인 항목을 확인한다.
- 자격 증명 접근은 엄격하게 읽기 전용이다. CodexIsland는 OAuth 토큰을 갱신하거나
  Claude의 자격 증명 저장소에 쓰지 않는다. 액세스 토큰이 만료되면 `claude`를
  실행하고, 엔드포인트가 새로 스코프된 토큰을 요구하면 `claude /login`을 실행한다.
- 어느 것도 동작하지 않으면 패널에 `auth required — run claude`가 표시된다.

첫 번째 페치는 앱 실행 시 시작되므로 보통 첫 peek 시점에는 패널에 값이 준비되어 있다. 설정을 열어도 새 페치가 트리거된다.
## 앱 사용하기

- 노치에 마우스를 올리면 현재 5시간 사용량을 미리 볼 수 있다.
- 아일랜드를 클릭하면 전체 패널이 확장된다.
- 패널에서 좌우로 스와이프하거나 인디케이터 점을 사용해
  **Usage**, **Cost**, **Overview** 사이를 이동한다.
- 마우스를 벗어나면 다시 접힌다.
- 확장된 패널을 Command-클릭하면 현재 화면의 차트 스타일이 순환한다
  (Usage는 Ring/Bar/Stepped/Numeric/Sparkline, Cost는
  USD/VALUE/TOKENS/TREND, Overview는 캘린더 뷰 하나만 있다).
- 패널 헤더의 `synced Xs ago`를 클릭하면 즉시 다시 가져온다.
- 확장된 패널 왼쪽 아래 모서리의 톱니바퀴를 클릭하거나 ⌘,를 누르면
  Settings가 열린다.
- 포인터가 아일랜드 위에 있는 상태에서 ⌘Q를 누르면 종료된다. Settings에서도
  종료할 수 있다.

프로바이더 표시 설정은 화면 표기에만 영향을 준다. 프로바이더를 숨기면 아일랜드에서
해당 프로바이더의 로고와 열이 사라지지만, 앱은 최신 사용량 값을 메모리에 유지하므로
다시 표시할 때 초기화가 필요하지 않다.
## 설정

설정은 시스템 설정 씬이 아닌 커스텀 `NSWindow`다. 앱은 여전히 Dock 아이콘과 메뉴 바 없이 액세서리 앱으로 실행된다.

- **일반:** 로그인 시 실행, 5분/15분/30분 새로고침 주기, 앱 언어, 사용량 항상 표시, 저전력 모드, 설정 가능한 한도 알림, Sparkle 업데이트 제어.
- **표시:** 사용/잔여 백분율, 사용량 및 비용 시각화 스타일, 대상 디스플레이, 노치 없는 화면에서의 아일랜드 너비.
- **공급자:** Claude/Codex 표시 여부 및 상태, 토큰 계산 모드, 로컬 비용 데이터 수동 새로고침. 비용 추정치는 USD, CNY, EUR, GBP, JPY, KRW, CAD, AUD, CHF로 표시할 수 있다. 환산에는 캐시된 일일 기준 환율을 사용하며, 기반이 되는 모델 가격과 비용 계산은 USD로 유지된다. 모델 가격과 마찬가지로 환율은 시작 시 캐시에서 로드되고 6시간마다 확인하여 24시간 이상 지난 경우 가져온다. 새로고침 시 환율도 갱신된다. 통화 선택은 공유 캐시 테이블을 사용하며, 오프라인일 때는 마지막 유효 테이블이 유지된다(또는 테이블을 사용할 수 있을 때까지 USD로 표시된다).

환경설정은 `UserDefaults`에 `MacIsland.*` 키로 저장된다(Sparkle은 자체 `SU*` 업데이트 키를 관리하고, 로그인 시 실행은 `SMAppService.mainApp`을 사용한다). 새로고침, 표시, 공급자 변경은 즉시 적용되며, 앱 언어를 변경하면 CodexIsland 재시작 여부를 묻는다.
## 소스에서 빌드하기

macOS 13 이상과 Xcode / Command Line Tools의 Swift 툴체인이 필요하다.

```sh
git clone https://github.com/ericjypark/codex-island
cd codex-island
./build.sh
open build/CodexIsland.app
```

Xcode 프로젝트도 SwiftPM 패키지도 없다. `build.sh`는 `Sources/**/*.swift`에 대해
`swiftc`를 실행하고, arm64와 x86_64 슬라이스를 컴파일한 뒤 `lipo`로 병합하고,
번들 리소스를 복사하고, `Info.plist`를 작성한다.

네이티브 앱 스모크 테스트:

```sh
./scripts/run-tests.sh
./scripts/verify.sh
```

`run-tests.sh`는 자격 증명 해석 및 노치 높이 테스트 하네스를 컴파일하고 실행한다.
`verify.sh`는 앱을 빌드하고 바이너리를 1초간 실행한 뒤, 여전히 살아 있으면 종료시킨다.

### 나만의 복사본 빌드하기

이 포크는 **기본적으로 업데이트 피드를 내장하지 않는다.** 따라서 이 소스로 만든
빌드는 온전히 당신의 것이다. 업스트림 릴리스로 스스로를 교체하지 않으며,
당신의 변경 사항을 함께 가져가지도 않는다. 원하는 이름을 붙이면 기존 복사본과
나란히 설치된다:

```sh
APP_NAME=MyIsland ./build.sh
cp -R build/MyIsland.app /Applications/
```

| 변수 | 기본값 | 효과 |
|---|---|---|
| `APP_NAME` | `CodexIsland` | 번들 및 실행 파일 이름. 원본과 나란히 설치되도록 한다 |
| `DISPLAY_NAME` | `$APP_NAME` | Finder와 메뉴 막대에 표시되는 이름 |
| `BUNDLE_ID` | `dev.codexisland.CodexIsland` | 그대로 두면 기존 설정과 사용 기록을 물려받는다. 바꾸면 깨끗한 상태에서 시작한다 |
| `SU_FEED_URL` | *(비어 있음)* | 비어 있으면 Sparkle 키를 전혀 기록하지 않는다. 업데이터가 시작되지 않으며 설정에서 업데이트 섹션이 사라진다. 서명된 업데이트를 배포하려면 자신의 appcast URL을 지정한다 |

기본 앱을 Homebrew로 설치했다면 함께 제거하라 —
`brew uninstall --cask codexisland` — 그렇지 않으면 `brew upgrade`가 당신의 빌드
위에 다시 설치한다.
## 릴리즈

DMG 패키징:

```sh
npm install --global create-dmg
./release.sh
```

`release.sh`는 네이티브 빌드를 실행하고, `.app`을 `dist/`로 복사하며, ad-hoc
코드사이닝을 적용하고, `dist/CodexIsland-X.Y.Z.dmg`를 생성한 뒤, 가능한 경우 Sparkle의
EdDSA 키로 서명하고, `dist/appcast.xml`을 생성한 다음, 파일 크기와 SHA-256을
출력한다.

`v*` 태그를 푸시하면 `macos-15`에서 `.github/workflows/release.yml`이 트리거되어,
서명된 DMG와 appcast를 빌드하고, Conventional Commits에서 릴리즈 노트를 생성하며,
두 아티팩트를 GitHub Release에 게시하고, `HOMEBREW_TAP_TOKEN`이 설정된 경우
cask를 `ericjypark/homebrew-tap`에 미러링한다.

`Casks/codexisland.rb`는 Homebrew Cask 템플릿이다. 일반 릴리즈에서는 버전이나
SHA를 수동으로 올리지 않는다. CI가 이 파일을 tap으로 복사하면서 태그와 새로 빌드된
DMG를 기준으로 해당 필드를 다시 작성한다.
## 저장소 구조

```text
.
├── Sources/
│   ├── App.swift
│   ├── Cost/                # Local-log cost + token aggregation
│   ├── Localization/        # Runtime localization helper
│   ├── Model/
│   ├── Theme/
│   ├── Update/              # Sparkle wrapper
│   ├── Usage/
│   ├── Views/
│   └── Window/
├── Resources/              # Icons, provider marks, localized strings
├── Assets/                 # README logo asset
├── Tests/                  # Bare-swiftc regression harnesses
├── docs/                   # Sparkle runbook, design specs
├── Casks/                  # Homebrew Cask template
├── scripts/                # Tests, native smoke test, Sparkle setup
├── build.sh                # Universal .app build
├── release.sh              # DMG packaging
└── VERSION
```
## 개인정보 보호

네이티브 앱 동작:

- 앱 텔레메트리 없음.
- 앱 분석 없음.
- 크래시 리포팅 없음.
- 프록시 서버 없음.
- CodexIsland는 자격 증명을 저장하지 않는다.
- 모델 가격은 하루에 한 번 GitHub에 호스팅된 공개 카탈로그
  ([codex-island-model-catalog](https://github.com/ericjypark/codex-island-model-catalog))에서 가져온다.
  이 요청에는 식별자, 토큰, 사용 데이터가 포함되지 않는다 — 정적 JSON 파일에 대한
  단순 GET일 뿐이며, 실패하면 앱은 로컬 캐시로 동작한다.
- Codex 토큰은 `~/.codex/auth.json`에서 로컬로 읽는다.
- Claude 토큰은 `CLAUDE_CODE_OAUTH_TOKEN`, Claude의 자격 증명 파일 또는
  macOS Keychain에서 읽는다. CodexIsland는 이를 절대 갱신하거나 기록하지 않는다.
- 토큰은 `chatgpt.com`과 `api.anthropic.com`에 대한 `Authorization` 헤더로만
  기기를 벗어난다.
- Cost 화면은 `~/.claude/projects/**/*.jsonl`(및 `~/.config/claude/...`,
  그리고 `CLAUDE_CONFIG_DIR`에 지정된 모든 경로)에서 로컬 Claude Code 세션 로그를,
  `~/.codex/sessions/`에서 Codex 세션 로그를,
  `~/.local/share/opencode/`에서 OpenCode 데이터를 읽는다. 집계는 전적으로
  기기에서 이루어진다 — 로그 내용은 어디에도 업로드되거나 공유되지 않는다.
- 기본 Claude 히스토리 탐색에는 `~/Library/Application Support/Claude/local-agent-mode-sessions/`에
  로컬로 미러링된 Cowork 세션 로그도 포함된다.
  수집된 사용량은
  `~/Library/Application Support/dev.codexisland.CodexIsland/usage-history.sqlite3`에 보관된다.
  이 데이터베이스에는 토큰 수, 모델, 타임스탬프, 불투명한 레코드 식별자가 들어 있으며,
  프롬프트나 응답, 자격 증명은 포함하지 않는다.

이 README 상단의 방문자 배지는 배지 요청 수를 세는 외부 `hits.sh` 이미지다.
네이티브 앱에 번들되지 않으며 앱이 이 이미지를 요청하지도 않는다.

네트워크 관련 코드는
[`Sources/Usage/UsageFetcher.swift`](Sources/Usage/UsageFetcher.swift)에 집중되어 있다.
로컬 로그 리더는 [`Sources/Cost/`](Sources/Cost/)에 있다.
## 문제 해결

**Claude에 `auth required — run claude`가 표시된다.**
터미널에서 `claude`를 한 번 실행하거나 Claude Desktop을 열어 자격 증명이 존재하도록 한다.

**Claude에 `token expired — run claude`가 표시된다.**
`claude`를 실행해 Claude Code가 자체 토큰을 갱신하도록 한다. CodexIsland는 의도적으로 토큰을 갱신하지 않는다.

**Claude에 `re-login: claude /login`이 표시된다.**
저장된 토큰에 사용량 엔드포인트가 현재 요구하는 스코프가 없다. `claude /login`을 실행해 새 스코프가 적용된 토큰을 발급받는다. 기존 토큰을 갱신하는 것만으로는 충분하지 않다.

**Codex에 `no codex auth`가 표시된다.**
Codex / ChatGPT CLI에 로그인하고 `~/.codex/auth.json`이 존재하는지 확인한다.

**Codex에 `auth expired — codex login`이 표시된다.**
`codex login`을 실행해 `~/.codex/auth.json`의 자격 증명을 갱신한다.

**오류 이후에도 앱이 오래된 값을 표시한다.**
의도된 동작이다. `UsageStore`는 새로고침이 오류만 반환할 경우 이전의 정상 값을 유지하므로, 일시적인 429가 패널을 0%로 만들지 않는다.

**30초 폴링을 선택할 수 없는 이유는?**
Anthropic이 계정 단위로 `/api/oauth/usage`에 공격적인 레이트 리밋을 적용한다. 앱은 5m, 15m, 30m만 제공한다.

**노치가 없어도 동작하는가?**
그렇다. 컴팩트한 메뉴 막대 알약 형태로 대체된다. 설정에서 더 넓은 노치 스타일 간격으로 전환할 수 있다.

**다중 모니터를 지원하는가?**
그렇다. 단, 한 번에 하나의 아일랜드만 표시된다. 자동 모드는 노치가 있는 디스플레이를 우선하고, 그다음 주 디스플레이를 선택한다. 설정에서 연결된 특정 디스플레이에 아일랜드를 고정할 수도 있으며, 해당 디스플레이가 분리되면 CodexIsland는 자동 모드로 되돌아간다.

**사용량 엔드포인트가 깨질 수 있는가?**
언젠가는 그럴 가능성이 높다. 두 제공자의 엔드포인트 모두 문서화되어 있지 않다. 패널에 파싱 오류나 HTTP 오류가 나타나기 시작하면 응답 형태를 첨부해 이슈를 열되 토큰은 가린다.

**Dock 아이콘이 없는 이유는?**
CodexIsland는 액세서리 앱이다. 확장된 아일랜드의 톱니바퀴로 설정을 열고, Settings -> Quit으로 종료한다.
## 알려진 제약

- 서명되지 않은 빌드는 dequarantine 또는 Open Anyway가 필요하다.
- Claude와 Codex의 사용량 엔드포인트는 문서화되어 있지 않다.
- 스파크라인 히스토리는 CodexIsland가 실행 중일 때 기록한 측정값만 포함한다.
  공급자는 과거 사용량 시계열을 제공하지 않는다.
- 다중 모니터 환경에서는 한 번에 하나의 디스플레이에 고정되거나 자동 선택된
  단일 아일랜드만 사용한다.
- 접근성 지원은 부분적이다. VoiceOver 레이블은 있으나 고대비 변형은 아직
  구현되지 않았다.
## 감사의 말

- [codexbar](https://github.com/steipete/codexbar) by Peter Steinberger —
  Claude 자격 증명 해석을 위한 auth-source 고고학.
- [claudecodeusage](https://github.com/RchGrav/claudecodeusage) by Rich Hickson
  - `/api/oauth/usage`의 `claude-code/2.1.121` User-Agent 요구 사항.
- [LaunchAtLogin-Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)
  by Sindre Sorhus — `SMAppService.mainApp`의 참조 형태.
- [Emil Kowalski](https://animations.dev) — 애니메이션 타이밍과 인터랙션
  원칙.
## 변경 이력

현재 릴리스 노트는 [GitHub Releases](https://github.com/ericjypark/codex-island/releases)를,
정리된 마일스톤 노트는 [CHANGELOG.md](CHANGELOG.md)를 참고한다.
## 라이선스

MIT - [LICENSE](LICENSE)를 참고한다.

<a href="https://www.star-history.com/?type=date&repos=ericjypark%2Fcodex-island">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=ericjypark/codex-island&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=ericjypark/codex-island&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=ericjypark/codex-island&type=date&legend=top-left" />
 </picture>
</a>
