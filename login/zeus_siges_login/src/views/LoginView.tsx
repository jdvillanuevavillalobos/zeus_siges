import React from 'react';
import LoginForm from '../components/LoginForm';
import './LoginView.less';

const LoginView: React.FC = () => {
  return (
    <div className="login-view">
      <LoginForm />
    </div>
  );
};

export default LoginView;
