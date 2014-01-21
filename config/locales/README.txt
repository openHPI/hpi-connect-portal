# READ THIS FIRST BEFORE CREATING NEW TRANSLATION RULES

**** defining a new translation rule ****

1. labels, buttons, headline, etc. have to be changed in the views
  Before: <h1> "Job Offers" </h1>
  After: <h1> <%= t("job_offers.headline") %> </h1>
  +note+ <%= %> has to be added in this case, since we are executing ruby logic!
  +note+ this syntax: t "job_offers.headline" is also possible but please use parenthesis to make it more robust against errors

2. add an entry (in this case) to the config/locales/views/job_offers/en.yml + de.yml file
  en.yml:
  
    en:
      job_offers:
        headline: "Job Offers"

  de.yml:

    de:
      job_offers:
        headline: "Stellenangebote"

Use Spaces not Tabs in yml.
If the changes are not displayed, restart the server.

**** models vs views ****

+ For each model a de.yml and en.yml file should be created in config/locales/models/MODELNAME
  - the MODELNAME folder name should be singular
  - the en.yml and de.yml files should contain all the model attributes with their corresponding names
  - Example:

      Before: <%= label_tag :employer %>
      After : <%= label_tag t("activerecord.attributes.job_offer.employer") %>

+ For each view a de.yml and en.yml file should be created in config/locales/views/VIEWNAME
  - the VIEWNAME folder name should be plural
  - the en.yml and de.yml files should contain all names for UI elements that are NOT either model attribute names or basic button names like "edit", "new", etc..
  -Example(the example from above):

        Before: <h1> "Job Offers" </h1>
        After: <h1> <%= t("job_offers.headline") %> </h1>




**** basic bootstrap elements ****

In the /config/locales/defaults folder there are 2 files: en.bootstrap.yml and de.bootstrap.yml which include translations for simple element names like "edit", "new", etc..




**** date formats ****

If a date is displayed, it is possible to internationalize the format of the date by doing this:

    Before: <%= job_offer.start_date %>
    After : <%= l(job_offer.start_date) %>




**** Switching between languages to test your language rules ****

+ At the moment the default language is english
+ If you want to switch to german, you have to pass the locale parameter in the url:
    http://localhost:3000/?locale=de