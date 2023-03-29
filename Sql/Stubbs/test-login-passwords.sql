-- 
-- Helper to check if any logins have a given password
-- Useful to verify insecure account login passwords.
--

declare @passwordToCheck nvarchar(255) = null;

set @passwordToCheck = N'some-noddy-password';

select name from sys.sql_logins where pwdcompare (@passwordToCheck, password_hash ) = 1

