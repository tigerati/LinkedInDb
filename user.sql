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
        full_name, address, email, encode(digest(password_hash,'sha256'),'hex'),
        profile_pic, bio, created_at, user_type
    )
    VALUES (
        v_full_name, v_address, v_email, v_password_hash,
        v_profile_pic, v_bio, NOW(), v_user_type
    );

    RAISE NOTICE 'User % has been successfully registered as %.', v_full_name, v_user_type;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_profile(
    user_id INT,
    website VARCHAR,
    linkedin_url VARCHAR
)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO tbl_profile (
        user_id,
        website,
        linkedin_url
    ) VALUES (
        user_id, website, linkedin_url
    );
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

-- add experience
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
    INSERT INTO tbl_userSkill (user_id, skill_id)
    VALUES (_user_id, _skill_id)
    ON CONFLICT (user_id, skill_id) DO NOTHING;

    RETURN 'Skill added (or already existed).';
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

-- Function to delete a user by user_id
CREATE OR REPLACE FUNCTION delete_user(p_user_id INT)
    RETURNS VOID AS $$
BEGIN
    -- First, check if the user exists
    IF EXISTS (SELECT 1 FROM Tbl_user WHERE user_id = p_user_id) THEN
        DELETE FROM Tbl_user WHERE user_id = p_user_id;
        RAISE NOTICE 'User with ID % has been deleted.', p_user_id;
    ELSE
        RAISE NOTICE 'User with ID % does not exist.', p_user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_react(
    _post_id INT,
    _user_id INT,
    _reaction_type VARCHAR
)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO tbl_reaction (post_id, user_id, reaction_type)
    VALUES (_post_id, _user_id, _reaction_type)
    ON CONFLICT (post_id, user_id)
    DO UPDATE SET reaction_type = EXCLUDED.reaction_type;
END;
$$ LANGUAGE plpgsql;

-- Function to delete a connection between two users
CREATE OR REPLACE FUNCTION delete_connection(p_user1_id INT, p_user2_id INT)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Tbl_Connection
        WHERE (user1_id = p_user1_id AND user2_id = p_user2_id)
           OR (user1_id = p_user2_id AND user2_id = p_user1_id)
    ) THEN
        DELETE FROM Tbl_Connection
        WHERE (user1_id = p_user1_id AND user2_id = p_user2_id)
           OR (user1_id = p_user2_id AND user2_id = p_user1_id);

        RAISE NOTICE 'Connection between % and % has been deleted.', p_user1_id, p_user2_id;
    ELSE
        RAISE NOTICE 'No connection exists between % and %.', p_user1_id, p_user2_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Display all posts that is public
CREATE OR REPLACE FUNCTION get_filtered_feed(_user_id int)
RETURNS TABLE (
                    author varchar,
                    content varchar,
                    media_url varchar,
                    posted_at timestamp
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            u.full_name,
            p.content,
            p.media_url,
            p.posted_at
        FROM Tbl_post p
        JOIN tbl_user u on p.author_id = u.user_id
        WHERE p.visibility = 'public';
        IF NOT FOUND THEN
            RAISE EXCEPTION 'User may not exist or the post is private.';
        END IF;
END;
$$ LANGUAGE plpgsql;