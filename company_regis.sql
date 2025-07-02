CREATE OR REPLACE FUNCTION register_company(
    p_user_id INT,
    p_industry VARCHAR,
    p_company_name VARCHAR,
    p_website VARCHAR,
    p_address VARCHAR,
    p_logo_url VARCHAR
)
RETURNS void AS
$$
DECLARE
    existing RECORD;
BEGIN
    -- Check if user exists and user_type = 'company' (optional, recommended)
    PERFORM 1 FROM Tbl_user WHERE user_id = p_user_id AND user_type = 'company';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User ID % does not exist or is not a company user.', p_user_id;
    END IF;

    -- Check duplicate company_name
    SELECT * INTO existing FROM Tbl_Company WHERE company_name = p_company_name;
    IF FOUND THEN
        RAISE EXCEPTION 'Company name "%" is already registered.', p_company_name;
    END IF;

    -- Insert company record
    INSERT INTO Tbl_Company (
        user_id, industry, company_name, website,
        address, logo_url
    )
    VALUES (
        p_user_id, p_industry, p_company_name, p_website,
        p_address, p_logo_url
    );

    RAISE NOTICE 'Company "%" registered successfully for user ID %.', p_company_name, p_user_id;
END;
$$ LANGUAGE plpgsql;
