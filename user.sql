CREATE OR REPLACE FUNCTION register_user(
    full_name VARCHAR,
    address VARCHAR,
    email VARCHAR,
    password_hash VARCHAR,
    profile_pic VARCHAR,
    bio TEXT,
    created_at VARCHAR,
    user_type VARCHAR
)
RETURNS void AS
$$
DECLARE
    existing_user RECORD;
BEGIN
    -- Validate user_type
    IF user_type NOT IN ('job_seeker', 'company') THEN
        RAISE NOTICE 'User type must be either ''job_seeker'' or ''company''.';
        RAISE EXCEPTION 'Invalid user_type: %, registration aborted.', user_type;
    END IF;

    -- Check for duplicate full_name + email
    SELECT * INTO existing_user
    FROM tbl_user
    WHERE full_name = full_name AND email = email;

    IF FOUND THEN
        RAISE EXCEPTION 'User with full name "%" and email "%" already exists.', full_name, email;
    END IF;

    -- Insert the user
    INSERT INTO tbl_user (
        full_name, address, email, password_hash,
        profile_pic, bio, created_at, user_type
    )
    VALUES (
        full_name, address, email, password_hash,
        profile_pic, bio, created_at::TIMESTAMP, user_type
    );

    RAISE NOTICE 'User % has been successfully registered as %.', full_name, user_type;
END;
$$ LANGUAGE plpgsql;
