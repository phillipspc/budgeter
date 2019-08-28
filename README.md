# Budgeter
[![Image from Gyazo](https://i.gyazo.com/db594bfb1d8d4b9168a4cfcbd776ac52.png)](https://gyazo.com/db594bfb1d8d4b9168a4cfcbd776ac52)
live link: https://mybudgeterapp.herokuapp.com (free tier server, may need to warm up)

This is my attempt to create a full featured budgeting app in Rails!  

You start by creating *Categories* (Food, Entertainment, etc.) and *Sub Categories* (Groceries, Eating Out) with monthly budgets. Then add your *transactions* and classify them appropriately. You can also add recurring transactions that will show up each month without needing to be re-added. The main dashboard makes it easy to see your spending activity and history, and whether or not you're staying within your budget.  

You can take things a step further by linking your bank/credit card account to easily import transactions. You can even set up rules so that Budgeter will map certain types of imported transactions with the right Category/Sub Category.

### Notable features:
- [Plaid](https://www.plaid.com) integration for transaction importing (disabled by default on new users, message me if youd like this enabled on your account!)
- Optional email alerts for pending transactions (requires access to plaid integration)
- [Chart.js](https://www.chartjs.org/) for visualizing spending data and history

### Development Philosophy & Challenges:
While the primary purpose of this app was to build a budgeting tool I could use myself, it's also a great way to hone my skills as a rails developer. One goal in particular was to [escape the SPA rabbit hole](https://medium.com/@jmanrubia/escaping-the-spa-rabbit-hole-with-turbolinks-903f942bf52c) and leverage some built in tools of Rails (notably Turbolinks and SJR) along with [Stimulus](https://stimulusjs.org/) to provide an experience that felt *close enough* to an SPA.

With that in mind, the dashboard was an important page to get right. Since it's a snapshot of your entire month, its pulling records from several different tables (transactions, categories, sub categories) as well as making some calculations (how much are you spending? what are the total budgets for each category?). I optimized these queries as much as possible to ensure the user could quickly tab left and right and see previous month's data. This resulted in the scopes you see on the [Category](https://github.com/phillipspc/budgeter/blob/master/app/models/category.rb#L11) and [SubCategory](https://github.com/phillipspc/budgeter/blob/master/app/models/sub_category.rb#L7) models.

Working with the Plaid API for transaction importing also introduced its fair share of challenges. Since the transaction import page is one I expected to be accessed frequently (and updated each time a transaction is imported/ignored), repeatedly fetching the entire month's transaction data from Plaid was clearly not the way to go (for performance and rate limiting reaons). I chose to store the response as a JSONB column on the PlaidImport model, which can be parsed and iterated upon, and refreshed when needed.

### Full Stack details and technologies used:
- Ruby 2.6.3, Rails 6 (release candidate 1)
- PostgresQL
- Deployed using Heroku
- [Devise](https://github.com/plataformatec/devise) for authentication
- [Stimulus](https://stimulusjs.org/) for the majority of interactivity
- [Bulma](https://bulma.io/) for styling
- [Plaid](https://www.plaid.com) for transaction importing
- [Chart.js](https://www.chartjs.org/) for... charts!
- [SendInBlue](https://www.sendinblue.com/) for mailing
- [Sentry](https://sentry.io/) for error monitoring
