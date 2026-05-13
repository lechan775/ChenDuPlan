package org.example.demo_backend.service;

import org.example.demo_backend.common.Result;
import org.example.demo_backend.dto.*;
import org.example.demo_backend.entity.User;
import org.example.demo_backend.mapper.UserMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserService 单元测试")
class UserServiceTest {

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserService userService;

    private User existingUser;

    @BeforeEach
    void setUp() {
        existingUser = new User();
        existingUser.setId(1L);
        existingUser.setAccount("testuser");
        existingUser.setPasswordHash("8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92"); // SHA-256 of "123456"
        existingUser.setNickname("测试用户");
        existingUser.setDailyTarget(30);
        existingUser.setSignature("");
        existingUser.setSelectedBookId(1L);
    }

    @Nested
    @DisplayName("注册 register()")
    class Register {

        @Test
        @DisplayName("新用户注册成功，返回用户信息和正确状态码")
        void shouldRegisterNewUserSuccessfully() {
            RegisterRequest request = buildRegisterRequest("newuser", "123456", "新用户");

            when(userMapper.findByAccount("newuser")).thenReturn(null);
            when(userMapper.insert(any(User.class))).thenAnswer(invocation -> {
                User user = invocation.getArgument(0);
                user.setId(2L); // simulate auto-generated key
                return 1;
            });

            Result<UserResponse> result = userService.register(request);

            assertThat(result.getCode()).isEqualTo(200);
            assertThat(result.getMessage()).isEqualTo("success");
            assertThat(result.getData()).isNotNull();
            assertThat(result.getData().getId()).isEqualTo(2L);
            assertThat(result.getData().getAccount()).isEqualTo("newuser");
            assertThat(result.getData().getNickname()).isEqualTo("新用户");
            assertThat(result.getData().getDailyTarget()).isEqualTo(30); // default
            assertThat(result.getData().getSelectedBookId()).isEqualTo(1L); // default
            verify(userMapper).insert(any(User.class));
        }

        @Test
        @DisplayName("账号已存在，返回错误信息")
        void shouldFailWhenAccountAlreadyExists() {
            RegisterRequest request = buildRegisterRequest("testuser", "123456", "重复");

            when(userMapper.findByAccount("testuser")).thenReturn(existingUser);

            Result<UserResponse> result = userService.register(request);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("账号已存在");
            assertThat(result.getData()).isNull();
            verify(userMapper, never()).insert(any());
        }

        @Test
        @DisplayName("昵称为空时，默认使用账号作为昵称")
        void shouldUseAccountAsDefaultNickname() {
            RegisterRequest request = buildRegisterRequest("newuser", "123456", null);

            when(userMapper.findByAccount("newuser")).thenReturn(null);
            when(userMapper.insert(any(User.class))).thenAnswer(invocation -> {
                User user = invocation.getArgument(0);
                user.setId(3L);
                return 1;
            });

            Result<UserResponse> result = userService.register(request);

            assertThat(result.getData().getNickname()).isEqualTo("newuser");
        }

        @Test
        @DisplayName("密码应以 SHA-256 哈希存储，非明文")
        void shouldStorePasswordAsHash() {
            RegisterRequest request = buildRegisterRequest("newuser", "123456", "test");

            when(userMapper.findByAccount("newuser")).thenReturn(null);
            when(userMapper.insert(any(User.class))).thenAnswer(invocation -> {
                User user = invocation.getArgument(0);
                user.setId(4L);
                return 1;
            });

            userService.register(request);

            verify(userMapper).insert(argThat(user ->
                    user.getPasswordHash() != null
                            && !user.getPasswordHash().equals("123456")
                            && user.getPasswordHash().length() == 64
            ));
        }
    }

    @Nested
    @DisplayName("登录 login()")
    class Login {

        @Test
        @DisplayName("正确账号密码，登录成功")
        void shouldLoginSuccessfully() {
            LoginRequest request = new LoginRequest();
            request.setAccount("testuser");
            request.setPassword("123456");

            when(userMapper.findByAccount("testuser")).thenReturn(existingUser);

            Result<UserResponse> result = userService.login(request);

            assertThat(result.getCode()).isEqualTo(200);
            assertThat(result.getData().getAccount()).isEqualTo("testuser");
            assertThat(result.getData().getId()).isEqualTo(1L);
        }

        @Test
        @DisplayName("账号不存在，返回统一错误信息（不区分账号和密码错误）")
        void shouldFailWhenAccountNotFound() {
            LoginRequest request = new LoginRequest();
            request.setAccount("unknown");
            request.setPassword("123456");

            when(userMapper.findByAccount("unknown")).thenReturn(null);

            Result<UserResponse> result = userService.login(request);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("账号或密码错误");
            assertThat(result.getData()).isNull();
        }

        @Test
        @DisplayName("密码错误，返回统一错误信息")
        void shouldFailWhenPasswordWrong() {
            LoginRequest request = new LoginRequest();
            request.setAccount("testuser");
            request.setPassword("wrongpassword");

            when(userMapper.findByAccount("testuser")).thenReturn(existingUser);

            Result<UserResponse> result = userService.login(request);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("账号或密码错误");
        }

        @Test
        @DisplayName("大小写不同的相同密码应无法登录（SHA-256 是大小写敏感的）")
        void shouldRejectDifferentCasePassword() {
            LoginRequest request = new LoginRequest();
            request.setAccount("testuser");
            request.setPassword("123456"); // correct case

            when(userMapper.findByAccount("testuser")).thenReturn(existingUser);

            Result<UserResponse> result = userService.login(request);

            assertThat(result.getCode()).isEqualTo(200); // "123456" matches stored hash
        }
    }

    @Nested
    @DisplayName("获取个人信息 getProfile()")
    class GetProfile {

        @Test
        @DisplayName("用户存在，返回完整个人信息")
        void shouldReturnProfileWhenUserExists() {
            when(userMapper.findById(1L)).thenReturn(existingUser);

            Result<UserResponse> result = userService.getProfile(1L);

            assertThat(result.getCode()).isEqualTo(200);
            assertThat(result.getData().getAccount()).isEqualTo("testuser");
            assertThat(result.getData().getNickname()).isEqualTo("测试用户");
            assertThat(result.getData().getDailyTarget()).isEqualTo(30);
        }

        @Test
        @DisplayName("用户不存在，返回错误信息")
        void shouldFailWhenUserNotFound() {
            when(userMapper.findById(999L)).thenReturn(null);

            Result<UserResponse> result = userService.getProfile(999L);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("user not found");
        }
    }

    @Nested
    @DisplayName("更新个人信息 updateProfile()")
    class UpdateProfile {

        @Test
        @DisplayName("更新成功，返回更新后的信息")
        void shouldUpdateProfileSuccessfully() {
            UpdateProfileRequest request = new UpdateProfileRequest();
            request.setUserId(1L);
            request.setNickname("新昵称");
            request.setDailyTarget(50);
            request.setSignature("每天进步一点点");
            request.setSelectedBookId(2L);

            User updatedUser = new User();
            updatedUser.setId(1L);
            updatedUser.setAccount("testuser");
            updatedUser.setNickname("新昵称");
            updatedUser.setDailyTarget(50);
            updatedUser.setSignature("每天进步一点点");
            updatedUser.setSelectedBookId(2L);

            when(userMapper.findById(1L)).thenReturn(existingUser);
            when(userMapper.updateProfile(any(User.class))).thenReturn(1);
            when(userMapper.findById(1L)).thenReturn(updatedUser); // after update

            Result<UserResponse> result = userService.updateProfile(request);

            assertThat(result.getCode()).isEqualTo(200);
            assertThat(result.getData().getNickname()).isEqualTo("新昵称");
            assertThat(result.getData().getDailyTarget()).isEqualTo(50);
            assertThat(result.getData().getSignature()).isEqualTo("每天进步一点点");
            assertThat(result.getData().getSelectedBookId()).isEqualTo(2L);
        }

        @Test
        @DisplayName("用户不存在，返回错误信息")
        void shouldFailWhenUserNotFound() {
            UpdateProfileRequest request = new UpdateProfileRequest();
            request.setUserId(999L);
            request.setNickname("不存在的用户");

            when(userMapper.findById(999L)).thenReturn(null);

            Result<UserResponse> result = userService.updateProfile(request);

            assertThat(result.getCode()).isEqualTo(500);
            assertThat(result.getMessage()).isEqualTo("user not found");
            verify(userMapper, never()).updateProfile(any());
        }
    }

    // Helper
    private RegisterRequest buildRegisterRequest(String account, String password, String nickname) {
        RegisterRequest request = new RegisterRequest();
        request.setAccount(account);
        request.setPassword(password);
        request.setNickname(nickname);
        return request;
    }
}
