import GetHelloWorldMessage from "../../application/usecases/GetHelloWorldMessage";

class HelloWorldController {
  constructor() {
    this.getHelloWorldMessage = new GetHelloWorldMessage();
  }

  getMessage() {
    return this.getHelloWorldMessage.execute();
  }
}

export default HelloWorldController;
