CREATE OR REPLACE FUNCTION sign_in(p_email VARCHAR, p_password VARCHAR)
RETURNS TEXT
AS $$
DECLARE
    v_user_id INT;
BEGIN
    SELECT user_id INTO v_user_id
    FROM Tbl_user
    WHERE email = p_email
      AND password_hash = encode(digest(p_password, 'sha256'), 'hex');

    IF v_user_id IS NULL THEN
        RETURN 'Invalid username or password.';
    ELSE
        RETURN 'Login successful';
    END IF;
END;
$$ LANGUAGE plpgsql;