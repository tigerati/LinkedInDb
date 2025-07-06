create or replace function isHired(
    _user_id int
)
returns void as
$$
BEGIN
    update tbl_jobseeker
    set ishiring = 'true'
    where user_id = _user_id;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION create_job_seeker(
    p_user_id INT,
    p_open_to_work BOOLEAN DEFAULT FALSE,
    p_career_goal VARCHAR DEFAULT NULL,
    p_preferred_industry VARCHAR DEFAULT NULL,
    p_resume_url VARCHAR DEFAULT NULL,
    p_is_hiring BOOLEAN DEFAULT FALSE
)
RETURNS TEXT AS $$
DECLARE
    user_role TEXT;
BEGIN
    -- Step 1: Check if user exists and is a job_seeker
    SELECT user_type INTO user_role
    FROM Tbl_user
    WHERE user_id = p_user_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User ID % does not exist.', p_user_id;
    END IF;

    IF user_role <> 'JobSeeker' THEN
        RAISE EXCEPTION 'User ID % is not a job seeker. Type: %', p_user_id, user_role;
    END IF;

    -- Step 2: Insert into Tbl_JobSeeker
    INSERT INTO Tbl_JobSeeker (
        user_id,
        open_to_work,
        career_goal,
        preferred_industry,
        resume_url,
        isHiring
    ) VALUES (
        p_user_id,
        p_open_to_work,
        p_career_goal,
        p_preferred_industry,
        p_resume_url,
        p_is_hiring
    );

    RETURN 'Job seeker profile created successfully.';
END;
$$ LANGUAGE plpgsql;