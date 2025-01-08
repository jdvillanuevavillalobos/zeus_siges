import { RemoteComponentAdapter } from "../../infrastructure/adapters/RemoteComponentAdapter";

export class RemoteComponentService {
  static loadComponent(modulePath: string) {
    return RemoteComponentAdapter.load(modulePath);
  }
}
