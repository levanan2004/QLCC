****************Engine****************
*Tech Stack*: Flutter + Firebase

****************Vai trò & luồng chính****************
Chủ sở hữu (Owner)

Tạo chung cư mới → sinh mã chung cư (ví dụ: ABC123), có thể tái tạo mã mới.

CRUD tầng, CRUD phòng (batch tạo nhiều phòng/tầng).

Thêm/Sửa/Xóa người thuê: gán người thuê vào phòng cụ thể.

CRUD dịch vụ (ví dụ: internet, gửi xe, nước, điện…; có giá, đơn vị tính, chu kỳ).

Khóa/Tạm ngưng tài khoản người dùng (không cho truy cập app hoặc không cho nhắn tin).

Thiết lập nội quy (rule list), ghi nhận vi phạm.

Tin nhắn nội bộ real-time theo mã chung cư (có thể chia kênh theo toàn nhà, từng tầng, từng phòng).

Thông báo (broadcast) đến cư dân trong cùng mã chung cư (FCM + in-app).

Quản lý hồ sơ người thuê (CCCĐ/địa chỉ/điện thoại/biển số xe…).

Người thuê (Tenant)

Nhập mã chung cư do chủ gửi để tham gia (đã có tài khoản Google → bổ sung thông tin còn thiếu).

Được chủ gán vào phòng → xem thông tin phòng, số phòng, dịch vụ đang áp dụng.

Xem nội quy, vi phạm của bản thân, thông báo mới.

Nhắn tin trao đổi với cư dân khác trong cùng mã chung cư (real-time).




****************Roles & Main Flows****************
Owner

Create a new building → generate a unique building code (e.g., ABC123), with the option to regenerate a new code.

CRUD Floors & Rooms → add, update, delete, or batch-create multiple floors and rooms.

Manage Tenants → add, edit, or remove tenants, and assign them to specific rooms.

CRUD Services → manage services such as internet, parking, water, electricity, etc., including pricing, unit, and billing cycle.

Lock/Suspend User Accounts → restrict users from accessing the app or sending messages.

Set Building Rules & Record Violations → define regulations and track tenant violations.

Internal Real-Time Messaging → chat system based on building code, with channels at building-wide, floor, or room levels.

Announcements (Broadcast) → send notifications to all tenants in the same building code (via FCM and in-app notifications).

Tenant Profile Management → maintain tenant details (e.g., national ID, address, phone number, vehicle license plate, etc.).

Tenant

Join a Building → enter the building code provided by the owner to register; if logging in via Google, complete any missing required information.

Assigned to a Room → once placed into a room by the owner, view room details, room number, and associated services.

View Regulations & Violations → check building rules, personal violations, and new announcements.

Real-Time Messaging → chat and interact with other residents within the same building code.
