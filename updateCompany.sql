CREATE OR REPLACE FUNCTION update_company_profile(
    _company_id int,
    _user_id int,
    _website varchar,
    _address varchar,
    _logo_url varchar
)
RETURNS void AS
$$
DECLARE
    existing RECORD;
BEGIN
    -- Validate user
    PERFORM 1 FROM Tbl_user WHERE user_id = _user_id AND user_type = 'company';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User ID % does not exist or is not a company user.', _user_id;
    END IF;

    -- Attempt update
    UPDATE tbl_company
    SET website = _website,
        address = _address,
        logo_url = _logo_url
    WHERE company_id = _company_id AND user_id = _user_id;

    -- Check if update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Company ID % does not exist.', _company_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_jobpost(
    _job_id int,
    _company_id int,
    _title varchar,
    _description varchar,
    _address varchar,
    _employment_type varchar,
    _salary_range varchar
)
RETURNS void AS
$$
BEGIN
    -- Attempt update
    UPDATE tbl_jobpost
    SET title = _title,
        description = _description,
        address = _address,
        employment_type = _employment_type,
        salary_range = _salary_range
    WHERE job_id = _job_id AND company_id = _company_id;

    -- Check if update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Job ID % or company ID % does not exist.', _job_id,_company_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_recruiter(
    _user_id INT,
    _company_id INT,
    _position VARCHAR,
    _recruiter_bio TEXT
)
RETURNS void AS
$$
BEGIN
    -- Attempt update
    UPDATE tbl_recruiter
    SET position = _position,
        recruiter_bio = _recruiter_bio
    WHERE user_id = _user_id AND company_id = _company_id;

    -- Check if update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User ID % or company ID % does not exist.', _user_id,_company_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_application(
    _application_id int,
    _user_id int,
    _job_id int,
    _is_available bool
)
RETURNS void AS
$$
BEGIN
    -- Attempt update
    UPDATE tbl_application
    SET is_available = _is_available
    WHERE application_id = _application_id AND job_id = _job_id AND user_id = _user_id;

    -- Check if update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Application ID % or Job ID % or User ID % does not exist.', _application_id, _job_id, _user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;