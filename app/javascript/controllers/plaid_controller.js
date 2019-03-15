import { Controller } from "stimulus"

export default class extends Controller {
  open() {
    this.handler.open()
  }

  get handler() {
    const controller = this

    return Plaid.create({
      clientName: 'Plaid Quickstart',
      // Optional, specify an array of country codes to localize Link
      countryCodes: ['US'],
      env: controller.data.get("env"),
      // Replace with your public_key from the Dashboard
      key: controller.data.get("publicKey"),
      product: ['transactions'],
      // Optional, use webhooks to get transaction and error updates
      // webhook: 'https://requestb.in',
      // Optional, specify a language to localize Link
      language: 'en',
      // Optional, specify a user object to enable all Auth features
      // user: {
      //   legalName: 'John Appleseed',
      //   emailAddress: 'jappleseed@yourapp.com',
      // },
      onLoad: function() {
        // Optional, called when Link loads
      },
      onSuccess: function(public_token, metadata) {
        // Send the public_token to your app server.
        // The metadata object contains info about the institution the
        // user selected and the account ID or IDs, if the
        // Select Account view is enabled.
        $.post(controller.data.get("createItemUrl"), {
          public_token: public_token,
          metadata: metadata
        });
      },
      onExit: function(err, metadata) {
        // The user exited the Link flow.
        if (err != null) {
          // The user encountered a Plaid API error prior to exiting.
        }
        // metadata contains information about the institution
        // that the user selected and the most recent API request IDs.
        // Storing this information can be helpful for support.
      },
      onEvent: function(eventName, metadata) {
        // Optionally capture Link flow events, streamed through
        // this callback as your users connect an Item to Plaid.
        // For example:
        // eventName = "TRANSITION_VIEW"
        // metadata  = {
        //   link_session_id: "123-abc",
        //   mfa_type:        "questions",
        //   timestamp:       "2017-09-14T14:42:19.350Z",
        //   view_name:       "MFA",
        // }
      }
    })
  }
}
