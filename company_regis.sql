-- Company registration
CREATE OR REPLACE FUNCTION register_company(
    p_user_id INT,
    p_industry VARCHAR,
    p_company_name VARCHAR,
    p_website VARCHAR,
    p_address VARCHAR,
    p_logo_url VARCHAR,
)
RETURNS void AS
$$
DECLARE
    existing RECORD;
BEGIN
    -- Check if user exists and user_type = 'company'
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


-- register_recruiter function
CREATE OR REPLACE FUNCTION register_recruiter(
    p_user_id INT,
    p_company_id INT,
    p_position VARCHAR,
    p_recruiter_bio TEXT
)
RETURNS void AS
$$
DECLARE
    user_exists BOOLEAN;
    company_exists BOOLEAN;
    already_registered BOOLEAN;
BEGIN
    -- Check if user exists
    SELECT EXISTS (
        SELECT 1 FROM Tbl_user WHERE user_id = p_user_id
    ) INTO user_exists;

    IF NOT user_exists THEN
        RAISE EXCEPTION 'User ID % does not exist.', p_user_id;
    END IF;

    -- Check if company exists
    SELECT EXISTS (
        SELECT 1 FROM Tbl_Company WHERE company_id = p_company_id
    ) INTO company_exists;

    IF NOT company_exists THEN
        RAISE EXCEPTION 'Company ID % does not exist.', p_company_id;
    END IF;

    -- Check if recruiter is already registered
    SELECT EXISTS (
        SELECT 1 FROM Tbl_Recruiter
        WHERE user_id = p_user_id AND company_id = p_company_id
    ) INTO already_registered;

    IF already_registered THEN
        RAISE EXCEPTION 'User ID % is already a recruiter for Company ID %.', p_user_id, p_company_id;
    END IF;

    -- Insert recruiter
    INSERT INTO Tbl_Recruiter (
        company_id, user_id, position, recruiter_bio
    )
    VALUES (
        p_company_id, p_user_id, p_position, p_recruiter_bio
    );

    RAISE NOTICE 'Recruiter (User ID %) registered for Company ID %.', p_user_id, p_company_id;
END;
$$ LANGUAGE plpgsql;

-- create_job_post function
CREATE OR REPLACE FUNCTION create_job_post(
    p_company_id INT,
    p_title VARCHAR,
    p_description TEXT,
    p_address VARCHAR,
    p_employment_type VARCHAR,
    p_salary_range VARCHAR
)
RETURNS void AS
$$
DECLARE
    company_exists BOOLEAN;
BEGIN
    -- Check if the company exists
    SELECT EXISTS (
        SELECT 1 FROM Tbl_Company WHERE company_id = p_company_id
    ) INTO company_exists;

    IF NOT company_exists THEN
        RAISE EXCEPTION 'Company ID % does not exist.', p_company_id;
    END IF;

    -- Insert job post
    INSERT INTO Tbl_JobPost (
        company_id, title, description, address,
        employment_type, salary_range
    )
    VALUES (
        p_company_id, p_title, p_description, p_address,
        p_employment_type, p_salary_range
    );

    RAISE NOTICE 'Job post "%" has been successfully created by Company ID %.', p_title, p_company_id;
END;
$$ LANGUAGE plpgsql;

-- delete_company function
CREATE OR REPLACE FUNCTION delete_company(p_company_id INT)
    RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tbl_Company WHERE company_id = p_company_id) THEN
        DELETE FROM Tbl_Company WHERE company_id = p_company_id;
        RAISE NOTICE 'Company with ID % has been deleted.', p_company_id;
    ELSE
        RAISE NOTICE 'Company with ID % does not exist.', p_company_id;
    END IF;
END;
$$ LANGUAGE plpgsql;



-- delete_job_post function
CREATE OR REPLACE FUNCTION delete_job_post(p_job_id INT)
    RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tbl_JobPost WHERE job_id = p_job_id) THEN
        DELETE FROM Tbl_JobPost WHERE job_id = p_job_id;
        RAISE NOTICE 'Job post with ID % has been deleted.', p_job_id;
    ELSE
        RAISE NOTICE 'Job post with ID % does not exist.', p_job_id;
    END IF;
END;
$$ LANGUAGE plpgsql;