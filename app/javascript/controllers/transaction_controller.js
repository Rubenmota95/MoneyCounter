import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transaction"
export default class extends Controller {
static targets = ["graph", "transactions", "firstTransactions", "buttonShow", "buttonLess"]

  connect() {
    console.log("Working?");
  }
  hideGraph() {
    this.transactionsTarget.classList.remove("d-none");
    this.firstTransactionsTarget.classList.add("d-none");
    this.buttonShowTarget.classList.add("d-none");
    this.buttonLessTarget.classList.remove("d-none");
  }

  showGraph() {
    this.transactionsTarget.classList.add("d-none");
    this.firstTransactionsTarget.classList.remove("d-none");
    this.buttonShowTarget.classList.remove("d-none");
    this.buttonLessTarget.classList.add("d-none");
  }
}
