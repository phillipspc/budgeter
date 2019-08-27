# Budgeter
live link: https://mybudgeterapp.herokuapp.com (free tier server, may need to warm up)

This is my attempt to create a full featured budgeting app in Rails!  

You start by creating *Categories* (Food, Entertainment, etc.) and *Sub Categories* (Groceries, Eating Out) with monthly budgets. Then add your *transactions* and classify them appropriately. You can also add recurring transactions that will show up each month without needing to be re-added. The main dashboard makes it easy to see your spending activity and history, and whether or not you're staying within your budget.  

You can take things a step further by linking your bank/credit card account to easily import transactions. You can even set up rules so that Budgeter will map certain types of imported transactions with the right Category/Sub Category.

Notable features:
- [Plaid](https://www.plaid.com) integration for transaction importing (disabled by default on new users)
- Optional email alerts for pending transactions (requires access to plaid integration)
- [Chart.js](https://www.chartjs.org/) for visualizing spending data and history
