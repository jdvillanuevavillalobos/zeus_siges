
import HelloWorldEntity from "../../domain/entities/HelloWorldEntity";

class GetHelloWorldMessage {
  execute() {
    const helloWorldEntity = new HelloWorldEntity("¡Hola desde el Microfrontend!");
    return helloWorldEntity.getMessage();
  }
}

export default GetHelloWorldMessage;