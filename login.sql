CREATE OR REPLACE FUNCTION sign_in(p_username VARCHAR, p_password VARCHAR)
RETURNS INT
AS $$
DECLARE
    v_user_id INT;
BEGIN
    SELECT user_id INTO v_user_id
    FROM Tbl_user
    WHERE username = p_username
      AND password_hash = encode(digest(p_password, 'sha256'), 'hex');

    IF v_user_id IS NULL THEN
        RAISE NOTICE 'Invalid username or password.';
        RETURN NULL;
    ELSE
        RETURN v_user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;