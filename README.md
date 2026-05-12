# wezterm-wsl2-config

> WSL2 + zsh 환경에서 **Mac처럼 쓰는** WezTerm 설정 & 종합 사용 가이드

Windows 노트북으로 옮겨와도 macOS의 터미널 사용 경험을 최대한 유지하기 위한 WezTerm 설정 모음. 키바인딩, 테마, 탭/Pane 관리를 한 번에 갖춘 즉시 사용 가능한 config.

---

## ✨ 주요 기능

- **🍎 Mac 스타일 키바인딩** — `Ctrl+C/V`가 선택 여부에 따라 복사/SIGINT를 똑똑하게 분기
- **🎨 Dracula 테마 + 커스텀 탭바** — 활성/비활성 탭이 한눈에 구분되는 보라색 강조
- **📊 정보 풍부한 탭 타이틀** — `● 1 │ zsh │ ~/project` 형식으로 프로세스와 위치를 자동 표시
- **⚡ vim 블록 비주얼 호환** — `Ctrl+Q`를 셸/vim까지 통과시켜 컬럼 편집 가능
- **🔀 vim 스타일 Pane 관리** — `Ctrl+Shift+HJKL`로 Pane 간 이동
- **🚀 WSL2 자동 진입** — WezTerm을 켜면 바로 Ubuntu 셸로 진입

---

## 📷 미리보기

> 스크린샷은 `images/preview.png`에 추가 예정

```
┌──────────────────────────────────────────────────────────┐
│  ❯ python train.py                                       │
│  epoch  1 │ loss 0.342 │ lr 1e-4                        │
│  epoch  2 │ loss 0.318 │ lr 1e-4                        │
│  ...                                                     │
├──────────────────────────────────────────────────────────┤
│  ❯ watch -n 1 nvidia-smi                                 │
│  GPU 0: A6000  │ 78°C │ 42GB/48GB                        │
└──────────────────────────────────────────────────────────┘
[ ● 1 │ python │ ~/flowtex ]  [ ○ 2 │ vim │ ~/configs ]
```

---

## 🔧 전제 조건

이 설정은 다음이 이미 갖춰진 환경을 가정합니다:

- ✅ **Windows 10/11**
- ✅ **WSL2 + Ubuntu** 설치 완료 (이 설정은 Ubuntu 24.04 기준)
- ✅ **zsh** 설치 및 기본 셸 설정 완료
- ✅ **WezTerm** 설치 — [공식 설치 가이드](https://wezterm.org/install/windows.html)

WSL2/zsh 설치가 아직이라면 [Microsoft WSL 설치 가이드](https://learn.microsoft.com/ko-kr/windows/wsl/install)와 [oh-my-zsh](https://ohmyz.sh/) 셋업을 먼저 끝내 주세요.

---

## 📦 설치

### 1. 리포 클론

```bash
git clone https://github.com/<유저명>/wezterm-wsl2-config.git
cd wezterm-wsl2-config
```

### 2. 설정 파일 배치

**PowerShell에서**:

```powershell
# WezTerm 설정 디렉토리 생성
mkdir -Force "$env:USERPROFILE\.config\wezterm"

# 파일 복사
Copy-Item wezterm.lua "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

또는 직접 복붙: `wezterm.lua`를 다음 경로에 저장
```
C:\Users\<유저명>\.config\wezterm\wezterm.lua
```

### 3. WSL 배포판 이름 확인

PowerShell에서:

```powershell
wsl -l -v
```

출력 예시:
```
  NAME             STATE           VERSION
* Ubuntu-24.04     Running         2
```

`NAME` 컬럼 값을 `wezterm.lua`에서 다음 라인에 정확히 반영:

```lua
default_domain = "WSL:Ubuntu-24.04",
```

### 4. 셸 사전 설정 (한 번만)

WSL의 zsh에서:

```bash
# vim의 Ctrl+Q (블록 비주얼)이 통과되도록 flow control 끄기
echo 'stty -ixon' >> ~/.zshrc
source ~/.zshrc
```

### 5. WezTerm 실행

WezTerm을 켜면 자동으로 Ubuntu 셸로 진입. `wezterm.lua` 수정 시 자동 리로드되어 즉시 반영됨.

---

## ⌨️ 키바인딩 치트시트

### 복사 / 붙여넣기

| 단축키 | 동작 |
|---|---|
| `Ctrl + C` | 선택 있으면 복사, 없으면 SIGINT (Mac의 `Cmd+C` 느낌) |
| `Ctrl + V` | 항상 붙여넣기 |
| `Ctrl + Shift + C/V` | 표준 복붙 (백업용) |

### Tab

| 단축키 | 동작 |
|---|---|
| `Ctrl + T` | 새 탭 |
| `Ctrl + W` | 탭 닫기 |
| `Ctrl + Tab` / `Ctrl + Shift + Tab` | 다음/이전 탭 |

### Pane

| 단축키 | 동작 |
|---|---|
| `Ctrl + \` | 위아래 분할 |
| `Ctrl + Alt + \` | 좌우 분할 |
| `Ctrl + Shift + W` | Pane 닫기 |
| `Ctrl + Shift + H/J/K/L` | Pane 이동 (vim 스타일) |
| `Ctrl + Shift + Alt + H/J/K/L` | Pane 크기 조절 |

### 기타

| 단축키 | 동작 |
|---|---|
| `Ctrl + X` | Copy 모드 진입 (키보드 텍스트 선택) |
| `Ctrl + Q` | vim 블록 비주얼 (셸로 통과) |
| `Ctrl + Shift + ,` | 설정 파일 열기 |
| `Ctrl + Shift + L` | 디버그 오버레이 |

전체 사용법과 워크플로우 예시는 [`docs/USAGE.md`](./docs/USAGE.md) 참조.

---

## 🛠️ 커스터마이징

### WSL 배포판 변경

```lua
default_domain = "WSL:Ubuntu-22.04",  -- 본인 환경에 맞게
```

### 폰트 변경

Nerd Font를 쓰고 싶다면 (powerlevel10k 아이콘 등):

```lua
local font_name = "JetBrainsMono Nerd Font"
```

Windows에 폰트 설치:
```powershell
choco install jetbrainsmono-nerd-font
```

### 테마 변경

WezTerm 내장 테마 [목록](https://wezterm.org/colorschemes/index.html) 중 선택:

```lua
color_scheme = "Tokyo Night",  -- 다른 추천: "Catppuccin Mocha", "Nord (base16)"
```

### 키바인딩 추가

`keys = { ... }` 배열에 추가:

```lua
-- 폰트 크기 조절 (Mac의 Cmd+= / Cmd+-)
{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

-- 검색 (Cmd+F)
{ key = "f", mods = "CTRL", action = wezterm.action.Search({ CaseSensitiveString = "" }) },
```

---

## ❓ 트러블슈팅

<details>
<summary><b>WezTerm 켰는데 PowerShell이 떠요</b></summary>

`default_domain`의 배포판 이름이 잘못된 경우입니다. PowerShell에서 `wsl -l -v` 결과의 `NAME` 컬럼을 정확히 반영하세요.
</details>

<details>
<summary><b>한글이 □로 깨져요</b></summary>

폰트 fallback 체인에 한글 폰트를 추가하세요:

```lua
local function font_with_fallback(name, params)
    local names = { name, "D2Coding", "Nanum Gothic Coding", "Apple Color Emoji" }
    return wezterm.font_with_fallback(names, params)
end
```
</details>

<details>
<summary><b>vim에서 <code>Ctrl+Q</code>가 안 먹어요</b></summary>

`~/.zshrc`에 `stty -ixon`이 추가되어 있는지 확인하세요:

```bash
grep ixon ~/.zshrc
stty -a | grep ixon  # 출력에 "-ixon"이 있어야 함
```
</details>

<details>
<summary><b>클립보드 동기화가 안 돼요</b></summary>

WSL에서 `clip.exe`가 접근 가능한지 확인:

```bash
which clip.exe
echo "test" | clip.exe
```

`clip.exe not found`면 `/etc/wsl.conf`에서 `appendWindowsPath = false`로 막아두지 않았는지 확인하세요.
</details>

<details>
<summary><b><code>Ctrl+C</code>로 프로세스가 안 끊겨요</b></summary>

선택된 텍스트가 있어서 복사로 동작 중입니다. `Esc`로 선택 해제 후 다시 `Ctrl+C`를 누르세요.
</details>

---

## 📂 파일 구조

```
wezterm-wsl2-config/
├── README.md           # 이 파일
├── wezterm.lua         # WezTerm 설정 본체
├── docs/
│   └── USAGE.md        # 종합 사용 가이드 (워크플로우, vim 블록 비주얼 등)
├── LICENSE             # MIT
└── .gitignore
```

---

## 🤝 기여

이슈/PR 환영합니다. 다른 WSL 배포판이나 셸(fish, nushell 등)용 변형도 좋아요.

---

## 📚 참고

- [WezTerm 공식 문서](https://wezterm.org/)
- [WezTerm 키바인딩 레퍼런스](https://wezterm.org/config/keys.html)
- [Dracula 테마](https://draculatheme.com/wezterm)
- [Microsoft WSL 가이드](https://learn.microsoft.com/ko-kr/windows/wsl/)

---

## 📄 라이선스

MIT
