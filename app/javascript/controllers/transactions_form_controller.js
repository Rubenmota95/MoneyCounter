import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transactions-form"
export default class extends Controller {
  static targets = ["group", "category"]
  static values = {
    categories: Object
  }

  handleChange(event) {
    console.log(event.target.value)
    this.categoryTarget.options.length = 1
    if (event.target.value === "Expense") {
      this.groupTarget.classList.remove("d-none")
      this.categoriesValue.expense.forEach(value => {
        this.categoryTarget.add(this.#buildOption(value))
      })
    } else if (event.target.value === "Income") {
      this.groupTarget.classList.add("d-none")
      this.categoriesValue.income.forEach(value => {
        this.categoryTarget.add(this.#buildOption(value))
      })
    }
  }

  #buildOption(value) {
      const option = document.createElement('option');
      option.text = value;
      option.value = value;
      return option;
  }
}
