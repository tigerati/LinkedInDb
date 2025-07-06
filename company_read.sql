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