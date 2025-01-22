import React from "react";
import HelloWorldController from "../interfaces/controllers/HelloWorldController";

const HelloWorld = () => {
  const helloWorldController = new HelloWorldController();
  const message = helloWorldController.getMessage();

  return <h1>{message}</h1>;
};

export default HelloWorld;
