# CLAUDE.md

このファイルは、Claude Code（claude.ai/code）がこのリポジトリのコードを扱う際のガイダンスを提供します。

## プロジェクト概要

Efficioは、SwiftUIとCore Dataで構築されたiOS向け生産性Todoリストアプリです。メインアプリターゲット（`Efficio`）、ホーム画面ウィジェット用のWidgetKit拡張（`EfficioWidgetExtension`）、テストターゲット（`EfficioTodoTest`）で構成されています。メインアプリとウィジェットは、App Group（`group.hapiharu012.Efficio.app`）を通じてデータを共有します。

## ビルドと実行

### ビルドコマンド

```bash
# シミュレータ向けビルド（iPhone 16または利用可能なデバイス）
xcodebuild -scheme Efficio -sdk iphonesimulator -configuration Debug build

# 実機向けビルド
xcodebuild -scheme Efficio -sdk iphoneos -configuration Debug build

# ビルド成果物のクリーンアップ
xcodebuild clean -scheme Efficio
```

### テストの実行

```bash
# ユニットテストの実行
xcodebuild test -scheme Efficio -destination 'platform=iOS Simulator,name=iPhone 16'
```

### Xcodeの使用

Xcodeで`Efficio.xcodeproj`を開きます。プロジェクトには3つのターゲットがあります：
- **Efficio**: メインiOSアプリ
- **EfficioWidgetExtension**: ウィジェット拡張

最小デプロイメントターゲット：iOS 16.0

## アーキテクチャ

### Core Dataモデル

アプリはCore Dataを使用して永続的なストレージを実現し、アプリとウィジェット拡張間で共有コンテナを使用します。データモデルは`Efficio.xcdatamodeld`で定義されています。

**Todoエンティティ**（`Todo+CoreDataClass.swift`、`Todo+CoreDataProperties.swift`）：
- `id`: UUID - 一意識別子
- `name`: String - タスク名
- `priority`: Int16 - 優先度（0=低、1=中、2=高）
- `state`: Bool - 完了状態
- `deadline_date`: Date? - 期日
- `deadline_time`: Date? - 期限時刻
- `order`: Int16 - 手動ソート用の表示順序

**主要な実装詳細**：
- App Groupによる共有Core Dataコンテナ：`group.hapiharu012.Efficio.app`
- データベースファイルの場所：`FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:)`
- 自動マイグレーション付きデータベースバージョニングシステム（`Persistence.swift:66-84`参照）
- データ変更後の`WidgetCenter.shared.reloadAllTimelines()`によるウィジェットタイムライン更新

### MVVMアーキテクチャ

**ViewModel**：
- `TodoViewModel`（`TodoViewModel.swift`）：TodoのCRUD操作、状態、Core Dataとのやり取りを管理
  - `NSManagedObjectContext`で初期化
  - `NSNotification.Name.NSManagedObjectContextDidSave`を通じてCore Dataの変更を監視
  - データ変更後に自動的にウィジェットをリロード
- `ThemeViewModel`（`ThemeViewModel.swift`）：UserDefaultsを介したアプリテーマを管理するシングルトン
  - キー`"Theme"`でテーマ選択を永続化
  - テーマとカラースキームに基づいて色を決定

**ビュー構造**：
- メインフロー：`EfficioApp.swift` → `SprashView.swift` → `ContentView.swift`
- `ContentView.swift`：フィルタリング、追加/削除ボタンを備えたメインTodoリストインターフェース
- `AddTodoView.swift`：Todo作成/編集用シート
- `TodoDetailView.swift`：個別Todoの詳細ビュー
- `TodoItemView.swift`：再利用可能な行コンポーネント
- `SettingView.swift`：テーマとアプリ設定

**モデル**：
- `Models/`ディレクトリ内のCore Dataエンティティ
- `PersistenceController`：Core Dataスタックの初期化とマイグレーションを管理

### ウィジェット拡張

`EfficioWidget`ディレクトリには独立したWidgetKit拡張が含まれています：

**主要ファイル**：
- `EfficioWidget.swift`：タイムライン生成用の`Provider`を持つメインウィジェット設定
- `EfficioWidgetSmallView.swift`：小サイズウィジェットレイアウト
- `EfficioWidgetMediumView.swift`：中サイズウィジェットレイアウト
- `EfficioWidgetCircular.swift`：ロック画面用円形ウィジェット
- `EfficioWidgetRectangular.swift`：ロック画面用長方形ウィジェット
- `TodoToggle.swift`：ウィジェットからTodo状態を切り替える共有コンポーネント

**サポートされるウィジェットファミリー**：
- `.systemSmall`、`.systemMedium`
- `.accessoryCircular`、`.accessoryRectangular`（iOS 16以降）

ウィジェットは`@FetchRequest`を使用して共有Core Dataにアクセスし、`order`と`state`でソートされたTodoを表示します。

### テーマシステム

テーマは`ThemeViewModel.shared`（シングルトン）で管理されます：
- `ThemeData.swift`のテーマ設定
- `ThemeModel.swift`のテーマモデル
- テーマは背景色、行の色、アクセントカラーを定義
- テーマ選択はUserDefaultsに永続化
- テーマ+カラースキームに基づいてフォント色を決定するメソッド

### ユーティリティ

- `PriorityUtils.swift`：優先度関連操作のユーティリティ関数
- `Calendar+Extensions.swift`：日付/カレンダーヘルパー拡張（アプリとウィジェットで別々のコピーあり）
- `View+Extension.swift`：SwiftUIビュー拡張

## 一般的なパターン

### 新しいTodoの追加

1. ユーザーが追加ボタンをタップ → `todoModel.isNewTodo = true`を設定
2. シートとして`AddTodoView`を表示
3. ビューが保存時に`todoModel.writeTodo(context:)`を呼び出し
4. 自動的にウィジェットタイムラインをリロード

### 既存Todoの編集

1. ユーザーがTodoを選択 → `todoModel.editTodo(todo:)`を呼び出し
2. フォームフィールドを入力し、`isEditing`参照を設定
3. 保存時、`writeTodo`が`isEditing != nil`を検出して既存エンティティを更新

### アプリとウィジェット間のデータ共有

両ターゲット：
1. エンタイトルメントで同じApp Group識別子を使用
2. 共有コンテナURLで`PersistenceController`を初期化
3. ウィジェットがメインアプリと同じCore Dataストアを監視
4. アプリがデータ変更後に明示的にウィジェットタイムラインをリロード

### データベースバージョン管理

アプリには自動データベースマイグレーションロジックが含まれています（`Persistence.swift`）：
- 現在のDBバージョンは定数として保存：`currentDBVersion = "2.0.0"`
- バージョン不一致時、古いストアファイル（メイン、WAL、SHM）を削除
- マイグレーションエラー（コード134140）は自動ストア削除をトリガー

## コードスタイルに関する注意事項

- コードベース全体に日本語コメント

# 開発時のMCPについて
本プロジェクトでは以下のmcpが利用できます。
適宜必要に応じて使用してください。
- apple-docs
  - Apple Developer Documentation（Appleの開発者向けドキュメント）に直接アクセスできるMCP
- context7
  - 最新かつ正確なコードドキュメントをリアルタイムで提供するツール
  - AIモデルは学習データの時点での情報に依存するため、古いAPIや存在しないメソッドを提案してしまうことがありますが、Context7を使うと公式ドキュメントの最新情報がAIのプロンプトコンテキストに直接注入され、正確かつ最新の情報に基づくコード提案が可能になります
- figma-remote-mcp
  - 開発中のアプリのデザインが見れます。
  - 指示内に"figmaに基づいてデザインをしてください"などの旨が書かれていれば参照しにいってください。
- notion
  - ユーザーのドキュメントへアクセスできます。
  - notionリンクが渡された時は使用してください
- XcodeBuildMCP
  - AIアシスタントやMCPクライアントがXcode関連のツールを利用できるようにしたもの
  - Xcodeプロジェクトのビルド、シミュレーターの操作、エラー検査などを自律的に行えるようになります