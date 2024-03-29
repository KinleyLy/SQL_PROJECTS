// https://preppindata.blogspot.com/2021/01/2021-week-1.html

SELECT 
  TRANSACTION_ID, 
  CONCAT('GB', CHECK_DIGITS , SWIFT_CODE , REPLACE(sort_code,'-','') , account_number) AS IBAN
FROM PD2023_WK02_TRANSACTIONS
LEFT JOIN PD2023_WK02_SWIFT_CODES ON pd2023_wk02_transactions.bank = pd2023_wk02_swift_codes.Bank;
