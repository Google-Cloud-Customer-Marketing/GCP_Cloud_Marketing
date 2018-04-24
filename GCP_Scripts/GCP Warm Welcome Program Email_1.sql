  --#GCP Warm Welcome Program Script Email 1#
  --This section pulls all the corporate podded stage 4 accounts and their respective sales rep names and ldap
SELECT
  DISTINCT (CASE
      WHEN (b.Full_Legal_Name__c IS NOT NULL AND trim(b.Full_Legal_Name__c) != "") THEN b.Full_Legal_Name__c
      ELSE a.account_name END) AS account_name,
  b.id sfdc_account_id,
  a.primary_is_rep sales_rep_ldap,
  e.preferred_name sales_rep_name,
  k.ilt,
  k.coursera,
  k.ql
FROM
  gcc.accounts.latest a
INNER JOIN
  eap.unify_account.newest b
ON
  a.sfdc_account_id = b.id
INNER JOIN
  eap.unify_opportunity.newest c
ON
  b.id = c.AccountId
LEFT OUTER JOIN
  PeopleView.Persons e
ON
  a.primary_is_rep = e.user_name
INNER JOIN
  andrewts.kickstarteligible k
ON
  b.id = k.sfdc_account_id
WHERE
  primary_is_rep IS NOT NULL
  AND trim(primary_is_rep) != ''
  AND segment = 'Corporate'
  AND StageName like '04%'
  AND b.Sales_Region__c = 'NORTHAM'
  and b.BillingCountry = 'US'
  --AND k.region = 'AMER'
  AND (ql != 0
    OR coursera != 0
    OR ilt !=0)
ORDER BY
  sales_rep_name;
