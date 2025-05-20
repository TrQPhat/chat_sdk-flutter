# Chat SDK

Gói SDK Flutter giúp tích hợp nhanh trang chatbot Midesk vào ứng dụng di động hoặc web chỉ với một dòng lệnh.

---

## 🚀 Cài đặt

Thêm vào file `pubspec.yaml`:

```yaml
dependencies:
  chat_sdk:
    git:
      url: https://github.com/midesk/chat_sdk.git
👉 Hoặc nếu đã được publish lên pub.dev:

yaml
Sao chép
Chỉnh sửa
dependencies:
  chat_sdk: ^1.0.0
⚙️ Cách sử dụng
dart
Sao chép
Chỉnh sửa
import 'package:chat_sdk/chat_sdk.dart';

ChatSdk.openChat(
  name: 'Nguyễn Văn A',
  phone: '0901234567',
  email: 'a.nguyen@example.com',
);
Gọi hàm sẽ mở link:

pgsql
Sao chép
Chỉnh sửa
https://uat-chatbot.midesk.vn/test/livechatmobie?name={name}&phone={phone}&email={email}
📄 Giấy phép
Gói này được phát hành theo MIT License.

🧑‍💻 Liên hệ & Hỗ trợ
Trang chủ: https://midesk.vn

Repository: https://github.com/midesk/chat_sdk

Issue Tracker: https://github.com/midesk/chat_sdk/issues
```
