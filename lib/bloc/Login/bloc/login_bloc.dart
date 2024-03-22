import 'package:bloc/bloc.dart';
import './login_event.dart';
import './login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_handleLoginRequested); // Đăng ký xử lý cho sự kiện LoginRequested
  }

  Future<void> _handleLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    // Phát ra trạng thái đang đăng nhập
    emit(LoginLoading());

    try {
      // Gửi yêu cầu đăng nhập bằng phương thức GET
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/0?username=${event.username}&password=${event.password}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(Duration(seconds: 10)); // Thiết lập thời gian chờ là 10 giây

      if (response.statusCode == 200) {
        // Xử lý phản hồi từ API để xác định đăng nhập có thành công hay không
        final responseData = response.body; // Giả sử phản hồi là một chuỗi JSON
        if (responseData == 'success') {
          emit(LoginSuccess(username: event.username)); // Đăng nhập thành công
        } else {
          emit(LoginFailure(error: 'Tên đăng nhập hoặc mật khẩu không chính xác')); // Đăng nhập thất bại
        }
      } else {
        // Xử lý phản hồi lỗi nếu status code khác 200
        emit(LoginFailure(error: 'Lỗi ${response.statusCode}: Đăng nhập không thành công'));
      }
    } catch (e) {
      // Xử lý lỗi nếu có lỗi xảy ra trong quá trình gửi yêu cầu hoặc nhận phản hồi từ API
      emit(LoginFailure(error: 'Lỗi: $e'));
    }
  }
}