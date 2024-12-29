// src/components/LoginForm.tsx
import React from 'react';
import { Form, Input, Button, Typography, Checkbox } from 'antd';
import { MailOutlined, LockOutlined } from '@ant-design/icons';
import './LoginForm.less';
import { useLoginViewModel } from '../viewmodels/LoginViewModel';

const { Title, Text } = Typography;

const LoginForm: React.FC = () => {
  // Usamos el ViewModel para manejar la lógica de negocio
  const { login, loading, errorMessage } = useLoginViewModel();

  const handleLogin = (values: { email: string; password: string }) => {
    const callback = window.location.search.split('callback=')[1] || '/'; // Extraer callback de la URL
    login(values.email, values.password, callback);
  };

  return (
    <div className="login-page">
      {/* Panel Izquierdo */}
      <div className="login-left-panel">
        <img src="/android-chrome-512x512.png" alt="Zeus Logo" className="logo" />
        <div className="welcome-section">
          <Title level={2} className="welcome-title">Bienvenido a ZEUS</Title>
          <Text className="welcome-description">
            Una plataforma integral para optimizar y gestionar tu negocio de manera eficiente.
          </Text>
        </div>
      </div>

      {/* Panel Derecho */}
      <div className="login-right-panel">
        <div className="login-form-container">
          <Title level={3} className="form-title">Iniciar Sesión</Title>
          <Form
            name="loginForm"
            onFinish={handleLogin}
            className="login-form"
            layout="vertical"
          >
            <Form.Item
              name="email"
              label="Correo Electrónico"
              rules={[{ required: true, message: 'Por favor ingrese su correo.' }]}
            >
              <Input prefix={<MailOutlined />} placeholder="Correo Electrónico" />
            </Form.Item>
            <Form.Item
              name="password"
              label="Contraseña"
              rules={[{ required: true, message: 'Por favor ingrese su contraseña.' }]}
            >
              <Input.Password prefix={<LockOutlined />} placeholder="Contraseña" />
            </Form.Item>
            <div className="form-options">
              <Checkbox>Recuérdame</Checkbox>
              <a href="#" className="forgot-password">¿Olvidaste tu contraseña?</a>
            </div>
            <Form.Item>
              <Button
                type="primary"
                htmlType="submit"
                className="login-button"
                loading={loading}
              >
                Iniciar Sesión
              </Button>
            </Form.Item>
            {errorMessage && <Text type="danger">{errorMessage}</Text>}
            <Text className="signup-text">
              ¿No tienes una cuenta? <a href="#">Regístrate aquí</a>.
            </Text>
          </Form>
        </div>
      </div>
    </div>
  );
};

export default LoginForm;
