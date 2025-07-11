CREATE OR REPLACE FUNCTION read_application(
    _application_id int,
    _user_id int,
    _job_id int
)
RETURNS TABLE
        (
            full_name varchar,
            title varchar,
            applied_date   DATE
        ) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        u.full_name,
        j.title,
        a.applied_date
    FROM tbl_application a
    JOIN tbl_user u ON a.user_id = u.user_id
    JOIN tbl_jobpost j ON a.job_id = j.job_id
    WHERE a.application_id = _application_id
      AND a.user_id = _user_id
      AND a.job_id = _job_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION read_jobpost(
    _job_id int,
    _company_id int
)
RETURNS TABLE
        (
            full_name varchar,
            title varchar,
            description text,
            address varchar,
            posted_at DATE,
            company_name varchar
        ) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        u.full_name,
        j.title,
        j.description,
        j.address,
        j.posted_at::DATE,
        c.company_name
    FROM tbl_jobpost j
    JOIN tbl_recruiter r ON j.company_id = r.company_id
    JOIN tbl_user u on r.user_id = u.user_id
    JOIN tbl_company c on j.company_id = c.company_id
    WHERE j.job_id = _job_id
      AND j.company_id = _company_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION count_applicant(
    _job_id int,
    _application_id int
)RETURNS INT AS $$
DECLARE
    applicant_count INT;
BEGIN
    SELECT COUNT(*) INTO applicant_count
    FROM tbl_application
    WHERE job_id = _job_id AND application_id = _application_id;

    RETURN applicant_count;
END;
$$ LANGUAGE plpgsql;


-- Function to get company profile by company_id
CREATE OR REPLACE FUNCTION get_company_profile(p_company_id INT)
    RETURNS TABLE (
                      company_id INT,
                      user_id INT,
                      industry VARCHAR,
                      company_name VARCHAR,
                      website VARCHAR,
                      address VARCHAR,
                      logo_url VARCHAR
                  )
AS $$
BEGIN
    RETURN QUERY
        SELECT
            c.company_id,
            c.user_id,
            c.industry,
            c.company_name,
            c.website,
            c.address,
            c.logo_url
        FROM Tbl_Company c
        WHERE c.company_id = p_company_id;
END;
$$ LANGUAGE plpgsql;

-- Read all job post from that company
CREATE OR REPLACE FUNCTION read_all_jobpost(_company_id int)
RETURNS TABLE (
                    title varchar,
                    content text,
                    applicants int
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            j.title,
            j.description,
            count_applicant(j.job_id, a.application_id)
        FROM Tbl_jobpost j
        JOIN tbl_application a on j.job_id = a.job_id
        WHERE j.company_id = _company_id;
END;
$$ LANGUAGE plpgsql;