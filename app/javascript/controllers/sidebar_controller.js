import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Sidebar controller carregado!");
  }

  toggle() {
    this.element.classList.toggle("-translate-x-full");
  }

  close() {
    this.element.classList.add("-translate-x-full");
  }
}
