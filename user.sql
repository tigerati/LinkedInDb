-- add user

CREATE OR REPLACE FUNCTION register_user(
    v_full_name VARCHAR,
    v_address VARCHAR,
    v_email VARCHAR,
    v_password_hash VARCHAR,
    v_profile_pic VARCHAR,
    v_bio TEXT,
    v_user_type VARCHAR
)
RETURNS void AS
$$
DECLARE
    existing_user RECORD;
BEGIN
    -- Validate user_type
    IF v_user_type NOT IN ('JobSeeker', 'company') THEN
        RAISE NOTICE 'User type must be either ''job_seeker'' or ''company''.';
        RAISE EXCEPTION 'Invalid user_type: %, registration aborted.', v_user_type;
    END IF;

    -- Check for duplicate full_name + email
    SELECT * INTO existing_user
    FROM tbl_user
    WHERE full_name = v_full_name AND email = v_email;

    IF FOUND THEN
        RAISE EXCEPTION 'User with full name "%" and email "%" already exists.', v_full_name, v_email;
    END IF;

    -- Insert the user
    INSERT INTO tbl_user (
        full_name, address, email, password_hash,
        profile_pic, bio, created_at, user_type
    )
    VALUES (
        v_full_name, v_address, v_email, v_password_hash,
        v_profile_pic, v_bio, NOW(), v_user_type
    );

    RAISE NOTICE 'User % has been successfully registered as %.', v_full_name, v_user_type;
END;
$$ LANGUAGE plpgsql;

-- add education
CREATE OR REPLACE FUNCTION add_education(
    user_id INT,
    school_name VARCHAR,
    degree VARCHAR,
    field_of_study VARCHAR,
    start_year INT,
    end_year INT
)
RETURNS void AS
$$
    INSERT INTO tbl_education (
        user_id,
        school_name,
        degree,
        field_of_study,
        start_year,
        end_year
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6
    );
$$ LANGUAGE SQL;

select add_education(
       2,
       'Oxford',
       'Undergraduate',
       'Computer Science',
       2000,
       2004
       );

select * from tbl_education;

CREATE OR REPLACE FUNCTION add_experience(
    user_id INT,
    company_name VARCHAR,
    title VARCHAR,
    start_date DATE,
    end_date DATE,
    description TEXT
)
RETURNS void AS
$$
    INSERT INTO tbl_experience (
        user_id,
        company_name,
        title,
        start_date,
        end_date,
        description
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6
    );
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION add_user_skill(
    _user_id INT,
    _skill_id INT
)
RETURNS TEXT AS
$$
BEGIN
    INSERT INTO tbl_userskill (user_id, skill_id)
    VALUES (_user_id, _skill_id);
    RETURN 'Skill added to user';
EXCEPTION
    WHEN unique_violation THEN
        RETURN 'This skill already exists for the user';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_user_skill_by_name(
    _user_id INT,
    _skill_name VARCHAR
)
RETURNS TEXT AS
$$
DECLARE
    _skill_id INT;
BEGIN
    -- Check if skill exists
    SELECT skill_id INTO _skill_id
    FROM tbl_skill
    WHERE skill_name = _skill_name;

    -- If not found, insert it
    IF NOT FOUND THEN
        INSERT INTO tbl_skill (skill_name)
        VALUES (_skill_name)
        RETURNING skill_id INTO _skill_id;
    END IF;

    -- Insert into UserSkill
    INSERT INTO tbl_userskill (user_id, skill_id)
    VALUES (_user_id, _skill_id);

    RETURN 'Skill added successfully';
EXCEPTION
    WHEN unique_violation THEN
        RETURN 'User already has this skill';
END;
$$ LANGUAGE plpgsql;


--Create application for Job Seeker
CREATE OR REPLACE FUNCTION send_application (
    user_id INT,
    job_id INT,
    is_available BOOL,
    applied_date DATE
)
RETURNS void AS
$$
BEGIN
    INSERT INTO tbl_application(
        user_id,
        job_id,
        is_available,
        applied_date
    )
    VALUES ($1, $2, $3, $4);
END;
$$ LANGUAGE plpgsql;

--Pending a connection between Users
CREATE OR REPLACE FUNCTION create_connection (
    user1_id INT,
    user2_id INT
)
RETURNS void AS
$$
BEGIN
    INSERT INTO tbl_connection(
        user1_id,
        user2_id,
        status,
        connected_at
    )
    VALUES (
        user1_id,
        user2_id,
        'pending',  -- default status
        CURRENT_DATE        -- connection not accepted yet
    );
END;
$$ LANGUAGE plpgsql;

--Accepting connection request
CREATE OR REPLACE FUNCTION accept_connection(
    _user1_id INT,
    _user2_id INT
)
RETURNS TEXT AS
$$
BEGIN
    -- Check if there is a pending connection
    IF EXISTS (
        SELECT 1 FROM tbl_connection
        WHERE user1_id = _user1_id AND user2_id = _user2_id AND status = 'pending'
    ) THEN
        -- Update status to accepted and set connected_at
        UPDATE tbl_connection
        SET status = 'accepted',
            connected_at = CURRENT_DATE
        WHERE user1_id = _user1_id AND user2_id = _user2_id;

        RETURN 'Connection accepted.';
    ELSE
        RETURN 'No pending request found.';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Rejecting connection request
CREATE OR REPLACE FUNCTION reject_connection(
    _user1_id INT,
    _user2_id INT
)
RETURNS TEXT AS
$$
BEGIN
    -- Check if there is a pending connection
    IF EXISTS (
        SELECT 1 FROM tbl_connection
        WHERE user1_id = _user1_id AND user2_id = _user2_id AND status = 'pending'
    ) THEN
        -- Update status to accepted and set connected_at
        UPDATE tbl_connection
        SET status = 'rejected',
            connected_at = CURRENT_DATE
        WHERE user1_id = _user1_id AND user2_id = _user2_id;

        RETURN 'Connection rejected.';
    ELSE
        RETURN 'No pending request found.';
    END IF;
END;
$$ LANGUAGE plpgsql;